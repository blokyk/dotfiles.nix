# The classic unix pager
{ lib, ... }:
let
  options = {
    # makes search ignore case *if* the query is all lowercase;
    # if there is an uppercase letter, search is case-sensitive
    ignore-case = true;

    # display both line number and pourcentage of file in status bar
    LONG-PROMPT = true;

    # enable mouse support in less
    mouse = true;

    # makes less display ANSI color sequences correctly instead of escaping them
    RAW-CONTROL-CHARS = true;

    # makes less automatically quit if the entire input can be displayed without paging
    quit-if-one-screen = true;

    # size of tab stops
    tabs = 4;
  };

  optToFlag = name: val:
    if val == true then
      "--${name}"
    else
      "--${name}=${toString val}";
in {
  programs.less = {
    enable = true;
    inherit options;
  };

  home.sessionVariables.LESS =
    lib.concatMapAttrsStringSep " " optToFlag options;
}
