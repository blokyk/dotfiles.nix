{
  formats,
  lib,
  nix,
  npins,
  runCommandLocal,
}:
let
  json = formats.json {};

  # generate an `npins/sources.json` file that just has
  # a single nixpkgs pin with the same version as the rest of the system
  nixpkgsPinJson = json.generate "sources.json" {
    pins.nixpkgs = removeAttrs (import <self/npins> {}).nixpkgs ["__functor" "outPath"];
    version = 8;
  };

  defaultParams = {
    project_name = "Placeholder";
    project_slug = "{{ cookiecutter.project_name.lower().replace(' ', '-') }}";
    author = "blokyk"; # todo: if only we could source this from home.username...
    _extensions = [
      "local_extensions.PrefetchExtension"
    ];
  };
in
{
  name,
  # the shell.nix file
  devshell,
  # arguments inside of `cookiecutter.json`
  params ? {},
}:

assert lib.isPath devshell || lib.isStorePath devshell
  || throw "The `devshell` argument should be a path, but is a ${lib.typeOf devshell}";
assert json.type.check params
  || throw "The `params` argument wasn't serializable to json";

let
  manifest = json.generate "cookiecutter.json" (defaultParams // params);
in
runCommandLocal name {} ''
  mkdir "$out"

  cp "${manifest}" "$out/cookiecutter.json"

  cp "${./prefetch.py}" "$out/prefetch.py"
  # replace nix-hash and nix-prefetch-url in the script with their actual executable path
  substituteInPlace "$out/prefetch.py" \
    --replace-fail '$nix-prefetch-url$' '${lib.getExe' nix "nix-prefetch-url"}' \
    --replace-fail '$nix-hash$' '${lib.getExe' nix "nix-hash"}'

  mkdir "$out/hooks"

  cp "${./pre_gen_project.sh}" "$out/pre_gen_project.sh"
  substituteInPlace "$out/pre_gen_project.sh" \
    --replace-fail '$npins$' '${lib.getExe npins}' \
    --replace-fail '$BASE_NPINS_JSON_PATH$' '${nixpkgsPinJson}'

  cutter="$out/"'{{ cookiecutter.project_slug }}'
  mkdir "$cutter"
  cp "${devshell}" "$cutter/shell.nix"
''
