# shellcheck shell=bash

{% if not cookiecutter.use_system_nixpkgs %}
    $npins$ init
{% else %}
    # if the user didn't want to use the system's nixpkgs version,
    # we'll have to fake the npins sources with a nix-generated file
    # that contains just the pin for nixpkgs (from pins.nixpkgs),
    # and an empty default.nix file that'll get properly gen'd by
    # running `npins upgrade`
    # fixme: rework this once npins#262 is fixed
    mkdir npins
    touch npins/default.nix
    cp $BASE_NPINS_JSON_PATH$ npins/sources.json
    $npins$ upgrade
{% endif %}

