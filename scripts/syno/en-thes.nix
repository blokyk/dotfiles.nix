{ runCommand }:
runCommand "en-thes" {
  src = <thesauruses>;
} ''
  mkdir $out
  cp $src/th_en_US_new.dat $out/thes_en.dat
  cp $src/th_en_US_new.idx $out/thes_en.idx
''
