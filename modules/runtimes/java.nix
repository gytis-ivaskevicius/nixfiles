{ config, pkgs, lib, ... }:
{
  programs.java.enable = true;
  programs.java.package = pkgs.jdk11;

  environment.systemPackages = with pkgs; [
 	maven
	gradle
  ];
}
