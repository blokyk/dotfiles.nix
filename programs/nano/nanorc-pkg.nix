{
  nanorc,
  ...
}:
nanorc.overrideAttrs {
  patches = [ ./git-commit-highlight-long-message.patch ];
}
