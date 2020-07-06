{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ nodejs ]; 
  programs.npm.enable = true;
  programs.npm.npmrc = ''
prefix=''${XDG_DATA_HOME}/npm
cache=''${XDG_CACHE_HOME}/npm
tmp=''${XDG_RUNTIME_DIR}/npm
init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
init-license=MIT
color=true
  '';

}
