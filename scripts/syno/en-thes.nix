{ fetchFromGitHub, runCommand }:
runCommand "en-thes" {
  src = fetchFromGitHub {
    owner = "hunspell";
    repo = "mythes";
    rev = "e43e32167d8cbcd94eef36895b39706946ce1479";
    hash = "sha256-m/pEpiktnFbOW7Ms1vkzVecCPLVi+gdCWI0MgPn8wTQ=";
  };
} ''
  mkdir $out
  cp $src/th_en_US_new.dat $out/thes_en.dat
  cp $src/th_en_US_new.idx $out/thes_en.idx
''
