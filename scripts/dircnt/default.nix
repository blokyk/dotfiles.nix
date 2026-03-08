{ runCommandCC }:
let
  pname = "dircnt";
  args = {
    executable = true;

    # not worth the network requests/bandwidth just for a single cc
    preferLocalBuild = true;
    allowSubstitutes = false;

    meta.mainProgram = pname;
  };
in
runCommandCC pname args ''
    mkdir -p $out/bin
    $CC \
      -Wall -Wextra -Wno-format-truncation \
      -fsanitize=address -g -O2 \
      -xc ${./dircnt.c} -o $out/bin/${pname}
  ''
