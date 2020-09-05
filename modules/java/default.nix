{ config, pkgs, lib, ... }:

let
  jdk8 = pkgs.jdk8;
  jdk11 = pkgs.jdk11;
  default_jdk = pkgs.jdk11;
in {
  programs.java.enable = true;
  programs.java.package = default_jdk;

  environment.variables = {
    JAVA_HOME8 = jdk8.home;
    JAVA_HOME11 = jdk11.home;
  };

  environment.shellAliases = {
    java8 = "${jdk8.home}/bin/java";
    java11 = "${jdk11.home}/bin/java";
  };

  environment.systemPackages = with pkgs; [
    jdk11
    jdk8
    maven
    gradle
  ];
}
