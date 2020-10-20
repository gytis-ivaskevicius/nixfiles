{ config, pkgs, lib, ... }:

let
  jdk8 = pkgs.jdk8;
  jdk11 = pkgs.jdk11;
  jdk14 = pkgs.jdk14;
  default_jdk = pkgs.jdk11;
in {
  programs.java.enable = true;
  programs.java.package = default_jdk;

  environment.variables = {
    JAVA_HOME8 = jdk8.home;
    JAVA_HOME11 = jdk11.home;
    JAVA_HOME14 = jdk14.home;
  };

  environment.shellAliases = {
    java8 = "${jdk8.home}/bin/java";
    java11 = "${jdk11.home}/bin/java";
    java14 = "${jdk14.home}/bin/java";
  };

  environment.systemPackages = with pkgs; [
    gradle
    jdk11
    jdk14
    jdk8
    maven
    visualvm
  ];
}
