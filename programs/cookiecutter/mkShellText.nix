# this file takes in a spec for a very basic devshell
# and generates the content of shell.nix (but not the file itself!)
{
  packages ? [],    # package names
  nixExts ? [],     # extensions from pkgs.vscode-extensions
  mktplcExts ? [],  # extensions from the marketplace
  useCC ? false,    # whether to use mkShell instead of mkShellNoCC
}:
let
  genList = spacing: packages:
    "\n" + spacing + builtins.concatStringsSep ("\n" + spacing) packages;

  mktplcSpecs = map (
    uuid:
      # we know that uuid will always be of the form `publisher.name`
      # so we turn it into `publisher", "name` and then `"publisher", "name"`
      # without ever having to split it
      let args = builtins.replaceStrings ["."] ["\", \""] uuid; in
      "{{ prefetch_vscode_ext(\"${args}\") }}"
  ) mktplcExts;
in ''
  let
    pins = import ./npins {};
    pkgs = import pins.nixpkgs {};
    vscode-ext-hook = pkgs.callPackage pins.vscode-ext-hook.outPath {};
  in
  pkgs.${if useCC then "mkShell" else "mkShellNoCC"} {
    packages = with pkgs; [${genList "    " (packages ++ ["vscode-ext-hook"])}
    ];

    vscodeExtensions =
      let
        nixExts = with pkgs.vscode-extensions; [${genList "        " nixExts}
        ];

        mktplcExts = pkgs.vscode-utils.extensionsFromVscodeMarketplace [${genList "        " mktplcSpecs}
        ];
      in nixExts ++ mktplcExts;
  }
''
