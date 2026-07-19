{ pkgs, ... }:
let
  nixpkgsExtensions = with pkgs.vscode-extensions; [
    # suggestions and go-to for path-like things, mainly files and folders
    christian-kohler.path-intellisense
    # linting (some might even even say *excessive pedantry*) for markdown files
    davidanson.vscode-markdownlint
    # nixd-compatible extension
    jnoortheen.nix-ide
    # clangd, a c++ lsp
    (pkgs.callPackage ./wrapped-clangd.nix {})
    # an adapter for the lldb debugger
    llvm-vs-code-extensions.lldb-dap
    # csharp lsp and debugger
    ms-dotnettools.csharp
    ms-dotnettools.csdevkit
    ms-dotnettools.vscode-dotnet-runtime
    # python syntax highlighting + language server
    ms-python.python
    ms-python.vscode-pylance
    # basic hex editor
    ms-vscode.hexeditor
    # better markdown previewer
    shd101wyy.markdown-preview-enhanced
    # bash script checking
    timonwong.shellcheck

    # highlights comments based on prefix (e.g. highlighting '// !' red)
    aaron-bond.better-comments
    # fixme: grrr this thing sucks all i really need from it are just the gutter-panel git blame
    eamodio.gitlens
    # configure vscode based on .editorconfig files in the repo
    editorconfig.editorconfig
    # finds 'todo:' and 'fixme:' comments and displays them by-file
    gruntfuggly.todo-tree
    # remote ssh stuff
    ms-vscode.remote-explorer
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    # multi-user live coding by a simple link
    ms-vsliveshare.vsliveshare
    # highlight trailing spaces at the end of lines
    shardulm94.trailing-spaces
    # code-spell code and comments
    streetsidesoftware.code-spell-checker
    streetsidesoftware.code-spell-checker-french
    # display errors and warnings inline with where they occur
    usernamehw.errorlens

    # one dark pro theme
    zhuangtongfa.material-theme
  ];

  marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    # a systemd unit file language server
    { name = "vscode-systemd-support"; publisher = "hangxingliu"; version = "3.0.0"; sha256 = "sha256-K1fXE0AxkWdHsQC3uUFcJecJqB5PpJVzVdtfPSw4+eg="; }

    # time tracker for repo, language, read/write ratio, etc.
    # todo: should we replace it with an active fork? (e.g. DavidLundholm.slashcoded-vscode-extension)
    { name = "vscode-coding-tracker"; publisher = "hangxingliu"; version = "0.6.0"; sha256 = "sha256-wZT0coYMPrdMVWOSA4FuYZ9v2AyeUocDFm/t6H+Ae9M="; }
    # create new files based on snippets and templates
    { name = "vscode-file-templates"; publisher = "rioj7"; version = "1.18.2"; sha256 = "sha256-oJMen+ioMxHoDPha8HWkHRNMCL8IbphFt2ChRdVDIso="; }
    # add a unique accent color to each window based on workspace path
    { name = "unique-window-colors"; publisher = "stuart"; version = "1.2.9"; sha256 = "0lbjnihxaznm2r6zh6a1mz96h89430ba6cr4k43qhpk2gpk3d2vf"; }

    # old icons from before <=1.105
    { name = "vscode-oldicons"; publisher = "adam-bender";  version = "0.2.0"; sha256 = "0p7k0safirn9bf459d5m77igdx8qd6b3rs8j0ndgjyvjlw54wkhs"; }
    # normal vscode icons w/ folder icons instead of '>'
    { name = "seti-minimal-folder"; publisher = "sabaken";  version = "1.0.3"; sha256 = "0ip528v3jpbyalpimw4myddmxfvr51bs5104lx5anad9icm37pm4"; }
    # nice light theme for when i need a light theme
    { name = "vscode-theme-onelight"; publisher = "akamud"; version = "2.3.0"; sha256 = "sha256-CTD0s2lRMCi/WCGr6dP1Utrvtsdcbg4srRcrZJSFDqU="; }
  ];
in {
  nixpkgs.config.allowUnfreePackages = [
    "vscode-extension-MS-python-vscode-pylance"
    "vscode-extension-ms-dotnettools-csharp"
    "vscode-extension-ms-dotnettools-csdevkit"
    "vscode-extension-ms-vscode-remote-explorer"
    "vscode-extension-ms-vscode-remote-remote-ssh"
    "vscode-extension-ms-vscode-remote-remote-ssh-edit"
    "vscode-extension-ms-vsliveshare-vsliveshare"
  ];

  programs.vscode.profiles.default.extensions = nixpkgsExtensions ++ marketplaceExtensions;
}
