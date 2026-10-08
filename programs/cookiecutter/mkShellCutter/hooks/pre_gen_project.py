import os
import shutil
import subprocess


class npins:
    # if the user didn't want to use the system's nixpkgs version,
    # we'll have to fake the npins sources with a nix-generated file
    # that contains just the pin for nixpkgs (from pins.nixpkgs),
    # and an empty default.nix file that'll get properly gen'd by
    # running `npins upgrade`
    # fixme: rework this once npins#262 is fixed
    @staticmethod
    def __init_nixpkgs():
        os.mkdir("npins")

        # create the empty npins/default.nix (that'll get upgraded later)
        open("npins/default.nix", "x").close()

        # copy the nix-generated system-nixpkgs-only pin file (but not its mode)
        shutil.copyfile("$BASE_NPINS_JSON_PATH$", "npins/sources.json")

        # finally, run `npins upgrade` to reify the npins/default.nix file
        subprocess.run(["$npins$", "upgrade"])

    @staticmethod
    def init(use_system_nixpkgs: bool):
        # if this project already uses npins, don't try to init it
        if os.path.exists("npins"):
            return

        if use_system_nixpkgs:
            return npins.__init_nixpkgs()

        subprocess.run(["$npins$", "init"])

    @staticmethod
    def add(args: list[str]):
        subprocess.run(["$npins$", "add"] + args)


class git:
    pass


npins.init({{ cookiecutter.use_system_nixpkgs }})

# fixme: this should be generalised
npins.add(["github", "blokyk", "vscode-ext-hook", "--branch", "main"])

# todo: probably git init?
