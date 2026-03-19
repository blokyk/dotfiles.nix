# this file is used to make an eval/build of a typical home-manager generation
# without using the `home-manager` command/CLI.
# it should be in `default.nix`, but unfortunately, that is already taken
# by the frozenpins injector fragment.
import <home-manager/home-manager/home-manager.nix> {
  confPath = ./home.nix;
  # check = false;
}
