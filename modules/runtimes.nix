{ config, pkgs, lib, ... }:
with lib;
let
  nodeCfg = config.gytix.node;
  javaCfg = config.gytix.java;
  defaultEnvVarialbes = {
    XDG_DATA_HOME = mkDefault "$HOME/.local/share";
    XDG_CACHE_HOME = mkDefault "$HOME/.cache";
    XDG_CONFIG_HOME = mkDefault "$HOME/.config";
  };
in
{
  options = {

    gytix.java.additionalPackages = mkOption {
      description = ''
        Java packages to install. Typical values are pkgs.jdk or pkgs.jre. Example:
        ```
          gytix.java.additionalPackages = {
            inherit (pkgs) jdk11 jdk14 jdk15;
          };
        ```
        This snippet:
        1. Generates environment variables `JAVA_HOME11` and `JAVA_HOME14`
        2. Generates aliases `java11` and `java14`
      '';
      default = { };
      type = with types; attrsOf package;
    };


    gytix.node.additionalPackages = mkOption {
      description = ''
        Node packages to install. Typical values are pkgs.nodejs-10_x or pkgs.nodejs-14_x. Example:
        ```
          gytix.node.additionalPackages = {
            inherit (pkgs) nodejs-14_x;
          };
        ```
        This snippet:
        1. Generates environment variables `JAVA_HOME11` and `JAVA_HOME14`
        2. Generates aliases `java11` and `java14`
      '';
      default = { };
      type = with types; attrsOf package;
    };
  };


  config =
    let
      escapeDashes = it: replaceStrings [ "-" ] [ "_" ] it;

      javaPkgs = javaCfg.additionalPackages;
      javaAliases = mapAttrs' (name: value: nameValuePair "java_${name}" "${value.home}/bin/java") javaPkgs;
      javaTmpfiles = mapAttrsFlatten (name: value: "L+ /nix/java${name} - - - - ${value.home}") javaPkgs;
      javaEnvVariables = mapAttrs' (name: value: nameValuePair "JAVA_HOME_${toUpper (escapeDashes name)}" "${value.home}") javaPkgs;

      nodePkgs = nodeCfg.additionalPackages;
      nodeAliases = mapAttrs' (name: value: nameValuePair name "${value}/bin/node") nodePkgs;
    in
    {
      environment.variables = javaEnvVariables // defaultEnvVarialbes;
      environment.shellAliases = javaAliases // nodeAliases;
      systemd.tmpfiles.rules = javaTmpfiles;

      programs.npm.npmrc = mkIf config.programs.npm.enable (mkDefault ''
        prefix=''${XDG_DATA_HOME}/npm
        cache=''${XDG_CACHE_HOME}/npm
        init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
        init-license=MIT
        color=true
      '');

      environment.shellInit = mkIf config.programs.npm.enable ''
        export PATH=$PATH:$XDG_DATA_HOME/npm/bin
      '';

    };
}
