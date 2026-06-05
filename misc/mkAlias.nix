{
  lib,
  symlinkJoin,
  writeShellApplication,
}:

{
  # name of the new command
  name ? pkg.pname,
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
  # whether this wrapper should have its files merged with the original
  # derivation's output (e.g. manpages, libraries, etc.)
  mergeWithBasePkg ? false,
}:
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

  meta = pkg.meta // {
    description = description;
    mainProgram = baseCmd;
  };

  wrapper = writeShellApplication (baseAttrs // {
    derivationArgs.preferLocalBuild = true;
    derivationArgs.meta = meta // { outputsToInstall = [ "out" ]; };
  });
in
  if mergeWithBasePkg then
    symlinkJoin {
      inherit meta;
      pname = name;
      version = pkg.version;
      paths = [
        # `symlinkJoin` will always take the first one if there's any conflict
        wrapper
        pkg
      ];
      # outputs = pkg.outputs;
      # postBuild = lib.concatMapStringsSep "\n" (out: ''
      #   ln -s ${pkg.${out + "Path"}} $${out}
      # '') (lib.filter (o: o != "out") pkg.outputs);
    }
  else
    wrapper
