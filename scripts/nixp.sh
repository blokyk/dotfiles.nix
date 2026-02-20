# shellcheck shell=bash

# print information about a given package (by default, from nixpkgs)

if [[ "${1:-}" = "-h" ]] || [[ "${1:-}" = "--help" ]]; then
    exe="$(basename "$0")"
    echo -e "\x1b[1m$exe: search packages and print info about them\x1b[0m"
    echo -e
    echo -e "usage:"
    echo -e "  $exe [--source|-s <pkgs>]"
    echo -e "    search for packages with fzf"
    echo -e "  $exe [--source|-s <pkgs>] <pkg-name>"
    echo -e "    display info about a given package"
    echo -e
    echo -e "options:"
    echo -e "  -[-s]ource <pkgs>    load the specified path instead of <nixpkgs>"
    echo -e "                       example: ./default.nix  ~/dev/nixpkgs  <my-channel>"
    exit 0
fi

getPkgInfo() {
    # compute all the properties in one eval, and print each on its own line
    {
        read -r name
        read -r version
        read -r desc
        read -r license
        read -r homepage
    } < <(
    # shellcheck disable=SC2016 # nope, those aren't bash variable substitution
    nix eval --raw --impure -E '
let
  inherit (builtins) concatStringsSep isList;
  pkg = (import '"$pkgs"' {}).'"$1"';
  listify = val: if (isList val) then val else [ val ];
  getLicenseName = l: l.spdxId or l.shortName or l.fullName or "unknown license";
  allLicenseNames =
    map getLicenseName (listify (pkg.meta.license or []));
in
'\'\''
${pkg.pname or pkg.name or "???"}
${pkg.version or "unknown"}
${pkg.meta.description or "<no description provided>"}
${concatStringsSep " / " allLicenseNames}
${pkg.meta.homepage or ""}
'\'\''
')

    # if there's a home page, set the name as a hyperlink to it; otherwise display it normally
    if [[ "$homepage" != "" ]]; then
        # shellcheck disable=SC1003 # this is the raw escape sequence, not a typo
        printf '\e]8;;%s\e\\\e[1m%s\e[0m\e]8;;\e\\ ' "$homepage" "$name"
    else
        printf '\e[1m%s\e[0m ' "$name"
    fi

    printf '\e[3m%s\e[0m \e[2m%s\e[0m\n' "$version" "$license"
    printf '\e[3m%s\e[0m\n' "$desc"
}
export -f getPkgInfo

pkgs='<nixpkgs>'
if [[ "${1:-}" = "-s" ]] || [[ "${1:-}" = "--source" ]]; then
    pkgs="$2"

    # once we've read the --source and <pkgs> from argv, remove then
    shift
    shift
fi
# needed for fzf to run getAllPkgs inside a sub-process
export pkgs

if [[ "${1:-}" = "" ]]; then
    # fuzzy-finding mode

    # strip the opening and closing '[]', then the quotes, and finally put each name on a separate line
    nixListToLines() {
        head --bytes=-2 | tail --bytes=+2 | tr ' ' '\n' | tr --delete '"'
    }

    # shellcheck disable=SC2329 # yes it's used, but indirectly by fzf
    # shellcheck disable=SC2016 # nope, those aren't bash variable substitution
    getAllPkgsSmart() {
        # display all normal package sets, and then display the ones inside package sets
        # by prefixing them with the package set name
        nix eval --impure -E '
let
  inherit (builtins) attrNames attrValues concatMap filter isAttrs mapAttrs partition tryEval;

  mapAttrsToList = f: set: attrValues (mapAttrs f set);
  # turn attrset into list of name/value pairs
  attrsToList = mapAttrsToList (name: value: { inherit name value; });

  rawPkgs = import '"$pkgs"' {};
  # only use packages we can evaluate AND (mainly for nixpkgs) that arent just a recursive definition
  pkgs = filter (pair: (tryEval pair.value).success && pair.value != rawPkgs) (attrsToList rawPkgs);

  isDrv = val: val.type or null == "derivation";
  _isPackageSet = val:
    isAttrs val && !isDrv val;
  isPackageSet = val:
    let e = (tryEval val).value; in
    if e == false then false
    else _isPackageSet e;

  # {
  #   right = [ { name = "fooPackages"; value = pkgs.fooPackages} ... ];
  #   wrong = [ { name = "hello"; value = pkgs.hello } ... ];
  # }
  splitPkgs = partition (pair: isPackageSet pair.value) pkgs;
  pkgSets = splitPkgs.right;

  # takes a pkgset and its name, and returns a list of all pkgs in the set
  # but with the set name as a prefix
  renameAllPkgsInPkgSet = pkgSetName: pkgSet:
    map (pkgName: "${pkgSetName}.${pkgName}") (attrNames pkgSet);

  normalPkgsNames = map (pair: pair.name) splitPkgs.wrong;
  pkgsInSetsNames =
    concatMap (pkgSet: renameAllPkgsInPkgSet pkgSet.name pkgSet.value) pkgSets;
in
  normalPkgsNames ++ pkgsInSetsNames
' \
        | nixListToLines
    }

    # shellcheck disable=SC2329 # yes it's used, but indirectly by fzf
    getAllPkgsDumb() {
        nix eval --impure -E 'builtins.attrNames (import '"$pkgs"' {})' \
            | nixListToLines
    }

    # shellcheck disable=SC2329 # yes it's used, but indirectly by fzf
    getAllPkgsAverage() {
        # shellcheck disable=SC2016 # nope, those aren't bash variable substitutions
        nix eval --impure -E 'let p = (import '"$pkgs"' {}); in builtins.filter (n: (builtins.tryEval p."${n}").success) (builtins.attrNames p)' \
            | nixListToLines
    }

    export -f getAllPkgsDumb getAllPkgsAverage getAllPkgsSmart nixListToLines
    # initially, display a list of all attrs inside <pkgs>, assuming all of them are normal packages.
    # however, in the background we're running a similar query that rewrites/explores the values
    # that are package sets; once it's done, we display the new refined list
    res="$(getAllPkgsDumb | SHELL="$(which bash)" fzf \
        --no-height \
        --preview-window 'bottom,25%' \
        --bind 'start:preview(echo "Loading packages")+reload-sync()' \
        --bind 'load:preview(echo "Refining package list")+reload-sync(getAllPkgsSmart)+unbind(load)' \
        --preview 'getPkgInfo {1}' \
        --preview-window wrap \
    )"
    unset -f getAllPkgsDumb getAllPkgsAverage getAllPkgsSmart nixListToLines

    # only print package info if not empty
    if [[ "$res" != "" ]]; then
        getPkgInfo "$res"
    fi
else
    # precise mode
    getPkgInfo "$1"
fi