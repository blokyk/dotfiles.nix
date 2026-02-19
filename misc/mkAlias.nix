{ writeShellApplication, lib, ... }:

{
  # name of the new command
  name,
  # pkg to base this on; if it has a main program,
  # this will also determine the command to run/alias
  pkg,
  # the command that will be aliased; by default, this is getExe(pkg)
  baseCmd ? (lib.getExe pkg),
  # flags to append to the start of the command
  flags,
  # whether the flags should be shell-escaped or not.
  # this is true by default, but if you need to use shell
  # variables you will have to turn it off and make sure
  # your arguments are properly escaped
  escapeFlags ? true,
  # a human-readable description/documentation of the alias
  description ? "alias to ${baseCmd} ${lib.concatStringsSep " " flags}",
  ...
}@args:
let
  formatFlag =
    if escapeFlags
      then lib.escapeShellArg
      # since `lib.escapeShellArg` uses toString (and not interpolation), we also have to use toString for consistency
      else (f: "\"${toString f}\"");
  flagsText =
    lib.concatMapStringsSep
      "\\\n  "
      formatFlag
      flags;

  baseAttrs = {
    inherit name;
    runtimeInputs = [ pkg ];

    text = ''
      ${baseCmd} \
        ${flagsText} \
        "''${@}"
    '';
  };

  passthru = removeAttrs args [ "name" "pkg" "baseCmd" "flags" "escapeFlags" ]; # note: leave `description` in the passthru
  mergeAttrs = a: b:
    lib.types.attrs.merge [] [{value=a;} {value=b;}];
in
  writeShellApplication (mergeAttrs baseAttrs passthru)