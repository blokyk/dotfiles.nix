let
  inherit (builtins) attrNames filter listToAttrs readDir stringLength substring;
  hasPrefix = pre: str: substring 0 (stringLength pre) str == pre;

  genAttrs' = xs: f: listToAttrs (map f xs);

  files =
    filter
      # don't import files that start with '-' (nor default.nix (obviously))
      (f: !hasPrefix "-" f && f != "default.nix")
      (attrNames (readDir ./.));
in
genAttrs'
  files
  (f: {
    name  = f;
    value = builtins.readFile (./. + ("/" + f));
  })

