{ lib, ... }:
let
  inherit (lib)
    attrsToList
    concatMapStringsSep
    concatMapAttrsStringSep
    elem
    isList
    isBool
    listToAttrs
    partition
    sortOn;
  inherit (lib.generators)
    mkKeyValueDefault
    mkValueStringDefault
    toKeyValue;

  mkRCValueString =
    opts: val:
      if (isList val)
      then
        concatMapStringsSep " " (mkRCValueString opts) val
      else
      if (isBool val)
        then if val then "1" else "0"
      else
        mkValueStringDefault opts val;

  # turns this declaration:
  #   screens = {
  #     "Main" = {
  #       columns = [ "PID" "USER" "PERCENT_CPU" ];
  #       sort_key = "PID";
  #       tree_view = false;
  #     };
  #   }
  # into the following:
  #   screen:Main=PID USER PERCENT_CPU
  #   .sort_key = PID
  #   .tree_view = 0
  mkRCScreenLines =
    { mkValueString, ... }@opts: sep: _: screens:
      let
        # we need to add '.' in front of the name of everything else
        mkScreenAttrLine = k: v: mkRCLine opts sep ".${k}" v;
        mkScreenLines =
          screenName: attrs:
            "screen:${screenName}${sep}${mkValueString attrs.columns}\n"
            + concatMapAttrsStringSep "\n" mkScreenAttrLine (removeAttrs attrs [ "columns" ]);

        # we need to sort the screens by an optional `order` property,
        # because nix attrsets don't have a defined order, and the way
        # htop has determines the default screen or screen order is
        # based on their definition's position in the config file
        sortedScreens =
          sortOn (kv: kv.value.order or 1000) (attrsToList screens);
      in
        concatMapStringsSep "\n" (kv: mkScreenLines kv.name kv.value) sortedScreens;

  mkRCLine =
    opts: sep: k: v:
      if (k == "screens")
        then
          mkRCScreenLines opts sep k v
        else
          mkKeyValueDefault opts sep k v;
in {
  generate =
    vals:
      let
        toKV = toKeyValue { mkKeyValue = mkRCLine { mkValueString = mkRCValueString { }; } "="; };

        # these config keys are special and should before the others
        specialAttrs = [ "htop_version" "config_reader_min_version" "header_layout" ];
        # therefore, we split them from the other values and print them first
        splitVals = partition (kv: elem kv.name specialAttrs) (attrsToList vals);
        specialAttrsOnly = listToAttrs splitVals.right;
        otherAttrs = listToAttrs splitVals.wrong;
      in
        (toKV specialAttrsOnly) + "\n" + (toKV otherAttrs);
}
