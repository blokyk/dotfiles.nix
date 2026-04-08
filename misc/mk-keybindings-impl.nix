/**
  Create a module that manages the keybindings of an app or services through dconf.

  The returned module creates an option at the given attr path and handles setting
  the keybindings at the requested dconf path (as well as checking that the keys
  used in each keybinding is valid).
  That option is an attribute set mapping action names to non-empty lists containing
  strings representing the individual keys in the keybinding. If an attribute is
  null, that keybinding is explicitely unset; on the other hand, not specifying
  an attribute will just not touch anything, thus leaving the dconf setting to
  what it is by default (the app's default, a previous setting, etc.).

  # Inputs

  `attrPath` :: [String]

  : The attribute path at which to add this option.
    For example, `attrPath = [ "programs" "gnome-shell" "keybindings" ]`
    will set `programs.gnome-shell.keybindings` to an option that
    behaves as specified above.

  `dconfPath` :: String

  : The dconf path the application stores keybindings at.
    For example, for gnome-shell this is `org/gnome/shell/keybindings`

  `multiKeybindings` :: Bool

  : Whether the application being configured supports actions being bound to multiple different keybindings.
    For example, gnome-shell does (and stores keybindings as lists);
    while tilix doesn't (and stores keybindings as strings).
*/
{ attrPath, dconfPath, multiKeybindings ? true, _check ? true }:
{ config, lib, ... }:
let
  inherit (lib) getAttrFromPath mapAttrs mkOption setAttrByPath types;

  keys =
    [
      "<Primary>" "<Control>" "<Ctrl>" "<Ctl>"
      "<Shift>" "<Shft>"
      "<Alt>"
      "<Meta>"
      "<Super>" "<Hyper>"
    ]
    ++ lib.lowerChars
    ++ lib.upperChars
    ++ [ "é" "è" "ç" "à" "ù" ]
    ++ [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ]
    ++ ["²" "&" "\"" "'" "(" "-" "_" ")" "=" "^" "$" "*" "," ";" ":" "!"]
    ++ lib.drop 1 (lib.genList (n: "F${toString n}") 25) # F1-F24
    ++ [
      "Up" "Down" "Left" "Right" "End"
      "space" "Space" "Above_Tab"
      "Home" "Print" "Escape"
      "XF86Keyboard"
    ]
  ;

  # we don't want the module system to merge two declarations
  # of a single keybinding, because then
  #   foo = [ "<Super>" "A" ];
  #   foo = [ "<Ctrl>"  "Z" ];
  # would get merged into a single keybinding
  #   foo = [ "<Super>" "A" "<Ctrl>" "Z" ];
  # and good luck typing that regularly :p
  nonMergeableList = t: (types.nonEmptyListOf t) // {
    merge = lib.options.mergeEqualOption;
  };

  # either a flat list like ["<Ctrl>" "C"], or a nested list of
  # different possible keybindings [ ["<Ctrl>" "C"] ["<Super>" "C"]]
  keybindingsType = with types;
    let singleKeybind = if _check then nonMergeableList (enum keys) else string; in
    if multiKeybindings then
      # in case we support multiple keybindings, we need to transform
      # single keybinds into a singleton list, so that we support
      # merging multiple declarations correctly
      coercedTo
        singleKeybind
        (val: [val])
        # this list *is* mergeable because it's fine if
        # there's multiple definitions for a single action,
        # since this supports multiple keybindings
        (nonEmptyListOf singleKeybind)
    else
      singleKeybind;

  opt = mkOption {
      type = with types; attrsOf (nullOr keybindingsType);
      default = { };
      example = {
        screenshot = [ "<Shift>" "Print" ];
        switch-layout = [ ["<Shift>" "Space"] ["<Super>" "Space"] ];
        toggle-message-tray = null;
      };
    };

in {
  options = setAttrByPath attrPath opt;

  config = {
    dconf.settings = {
      ${dconfPath} =
        let
          cfg = getAttrFromPath attrPath config;
          keysToStr = keys:
            if keys == null then
              ""
            else
              lib.concatStrings keys;
          multiToKeysStr = bindings:
            if bindings == null then
              []
            else
              # the lists of keys inside bindings can't ever be null,
              # so we don't have to worry about that
              map keysToStr bindings;
        in
          if multiKeybindings then
            mapAttrs
              (_: multiToKeysStr)
              cfg
          else
            mapAttrs
              (_: keysToStr)
              cfg;
    };
  };
}
