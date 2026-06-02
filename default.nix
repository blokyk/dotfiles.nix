let
  injector = import ./npins/inject.nix (pins: {
    # note: these are workaround for the weird nesting inherent to those module systems
    # (basically, home-manager will import <nixpkgs/lib/modules>, which will then import
    # our code, so the actual dependency chain looks like hm->nixpkgs->this to frozenpins)
    home-manager = pins;
    nixpkgs = pins;

    zoeee.nixpkgs = pins.nixpkgs;

    # note: in theory, this would override any subproject that
    #       also declares a `self` pin, but in our case we
    #       don't care because no one actually uses frozenpins :p
    self = pins // { outPath = ./.; };
  });
in
  # note: we don't just inline boostrap by using `injector.pins` because
  # we need to import a subfile of home-manager, and right now appending
  # to a frozenpins "project" object erases its project-ness (cf frozenpins#3)
  injector ./bootstrap.nix
