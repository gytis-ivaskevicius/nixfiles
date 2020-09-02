
{ config, pkgs, ... }:

{
  imports = [
    ../modules/java
    ../modules/node
  ];

  environment.systemPackages = with pkgs; [
    jetbrains.idea-ultimate
    gitkraken
    insomnia
  ];
}
