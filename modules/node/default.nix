{ config, pkgs, lib, ... }:
let
  node10 = pkgs.nodejs-10_x;
  node14 = pkgs.nodejs-14_x;
in {
  programs.npm.enable = true;
  programs.npm.npmrc = lib.mkDefault ''
    prefix=''${XDG_DATA_HOME}/npm
    cache=''${XDG_CACHE_HOME}/npm
    init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
    init-license=MIT
    color=true
  '';

  environment.systemPackages = with pkgs; [
    node10
    node14
  ];

  environment.shellAliases = {
    node10 = "${node10}/bin/node";
    npm10 = "${node10}/bin/npm";
    npx10 = "${node10}/bin/npx";

    node14 = "${node14}/bin/node";
    npm14 = "${node14}/bin/npm";
    npx14 = "${node14}/bin/npx";
  };

  environment.shellInit = ''
    export PATH=$PATH:$XDG_DATA_HOME/npm/bin
  '';

}
