{ config, pkgs, lib, ... }:

let
  jdk8 = pkgs.jdk;
  jdk11 = pkgs.jdk11;
  default_jdk = pkgs.jdk11;
in {
  programs.java.enable = true;
  programs.java.package = default_jdk;

  environment.variables = {
    JAVA_HOME8 = "${jdk8}/lib/openjdk/";
    JAVA_HOME11 = "${jdk11}/lib/openjdk/";
  };

  environment.shellAliases = {
    java8 = "${jdk8}/lib/openjdk/bin/java";
    java11 = "${jdk11}/lib/openjdk/bin/java";
  };

  environment.systemPackages = with pkgs; [
    jdk11
    jdk8
    maven
    gradle
  ];
}
