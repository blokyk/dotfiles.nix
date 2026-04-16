{ config, lib, ... }:
let
  inherit (lib)
    concatMapStringsSep
    mkOption
    literalExpression
    literalMD
    types;

  inherit (lib.hm) dag;

  cfg = config.programs.zsh;
in {
  options = {
    programs.zsh.initBlocks = mkOption {
      type = lib.hm.types.dagOf types.lines;
      description = ''
        A set of DAG blocks defining the sequence of commands to add to .zshrc
      '';
      default = { };

      example = literalExpression ''
        {
          "john.example.com" = {
            hostname = "example.com";
            user = "john";
          };
          foo = lib.hm.dag.entryBefore ["john.example.com"] {
            hostname = "example.com";
            identityFile = "/home/john/.ssh/foo_rsa";
          };
        };
      '';
    };
  };

  config = {
    programs.zsh.initContent =
      let
        sortedNodesRaw = dag.topoSort cfg.initBlocks;
        sortedNodes = sortedNodesRaw.result
            or throw "Dependency cycle in zsh init config: ${builtins.toJSON sortedNodesRaw}";

        blockToString = block: ''
          # ${block.name}
          ${block.data}
        '';
      in
        concatMapStringsSep "\n" blockToString sortedNodes;
  };
}
