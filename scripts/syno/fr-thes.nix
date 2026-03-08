{ fetchzip, runCommand }:
runCommand "fr-thes" {
  src = fetchzip {
    url = "https://www.grammalecte.net/dic/thesaurus-v3.0.zip";
    hash = "sha256-wHqWI7cyHio3/AAfH1g/yV3WO97Bh580RNqegWOnuK8=";
    stripRoot = false;
  };
} ''
  mkdir $out
  cp $src/thes_fr.dat $src/thes_fr.idx $out/
''
