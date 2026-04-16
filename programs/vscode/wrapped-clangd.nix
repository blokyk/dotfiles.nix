# by default, use the clangd from nixpkgs instead of searching $PATH
{
  vscode-extensions,
  clang-tools,
  lib,
}:
vscode-extensions.llvm-vs-code-extensions.vscode-clangd.overrideAttrs {
  # for some god-forsaken reason, using a patch doesn't work, so here i am,
  # using sed like some primitive caveman
  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"default": "clangd"' '"default": "${lib.getExe' clang-tools "clangd"}"'
  '';
}
