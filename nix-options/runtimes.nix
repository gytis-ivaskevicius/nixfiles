{ config, pkgs, lib, ... }:
let
  nodeCfg = config.gytix.node;
  javaCfg = config.gytix.java;
  defaultEnvVarialbes = {
    XDG_DATA_HOME = lib.mkDefault "$HOME/.local/share";
    XDG_CACHE_HOME = lib.mkDefault "$HOME/.cache";
    XDG_CONFIG_HOME = lib.mkDefault "$HOME/.config";
  };
in
{
  options = {

    gytix.java.additionalPackages = lib.mkOption {
      description = ''
        Java packages to install. Typical values are pkgs.jdk or pkgs.jre. Example:
        ```
          gytix.java.additionalPackages = {
            "11" = pkgs.jdk11;
            "14" = pkgs.jdk14;
          };
        ```
        This snippet:
        1. Generates environment variables `JAVA_HOME11` and `JAVA_HOME14`
        2. Generates aliases `java11` and `java14`
      '';
      type = with lib.types; attrsOf package;
    };


    gytix.node.additionalPackages = lib.mkOption {
      description = ''
        Node packages to install. Typical values are pkgs.nodejs-10_x or pkgs.nodejs-14_x. Example:
        ```
          gytix.node.additionalPackages = {
            "10" = pkgs.nodejs-10_x;
            "14" = pkgs.nodejs-14_x;
          };
        ```
        This snippet:
        1. Generates environment variables `JAVA_HOME11` and `JAVA_HOME14`
        2. Generates aliases `java11` and `java14`
      '';
      type = with lib.types; attrsOf package;
    };
  };


  config = {
    environment.variables = lib.fold (a: b: a // b) defaultEnvVarialbes (
      lib.mapAttrsFlatten (name: pkg: { "JAVA_HOME${name}" = pkg.home; }) javaCfg.additionalPackages
    );

    systemd.tmpfiles.rules = lib.mapAttrsFlatten (name: value: "L+ /nix/java${name} - - - - ${value.home}" ) javaCfg.additionalPackages;

    environment.shellAliases = lib.fold (a: b: a // b) { } (
      lib.mapAttrsFlatten (name: pkg: { "java${name}" = "${pkg.home}/bin/java"; }) javaCfg.additionalPackages
      ++ lib.mapAttrsFlatten (name: pkg: { "node${name}" = "${pkg.outPath}/bin/node"; }) nodeCfg.additionalPackages
    );

    programs.npm.npmrc = lib.mkDefault ''
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      init-license=MIT
      color=true
    '';

    environment.shellInit = lib.mkIf config.programs.npm.enable ''
      export PATH=$PATH:$XDG_DATA_HOME/npm/bin
    '';

  };
}
