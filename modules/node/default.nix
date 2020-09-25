{ config, pkgs, lib, ... }:
let
  node13 = pkgs.nodejs-13_x;
  node14 = pkgs.unstable.nodejs-14_x;
  default_node = pkgs.unstable.nodejs-14_x;
in {
  # Does not exist yet
  #programs.npm.package = default_node;
  programs.npm.enable = true;
  programs.npm.npmrc = lib.mkDefault ''
    prefix=''${XDG_DATA_HOME}/npm
    cache=''${XDG_CACHE_HOME}/npm
    init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
    init-license=MIT
    color=true
  '';

  environment.systemPackages = with pkgs; [
    node13
    node14
  ];

  environment.shellAliases = {
    node13 = "${node13}/bin/node";
    npm13 = "${node13}/bin/npm";
    npx13 = "${node13}/bin/npx";

    node14 = "${node14}/bin/node";
    npm14 = "${node14}/bin/npm";
    npx14 = "${node14}/bin/npx";
  };

  environment.shellInit = ''
    export PATH=$PATH:$XDG_DATA_HOME/npm/bin
  '';

}
