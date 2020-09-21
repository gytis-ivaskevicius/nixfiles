
{ config, pkgs, ... }:

{
  imports = [
    ../modules/java
    ../modules/node
    ../modules/docker
    ../modules/virtualbox
    #../modules/minikube
  ];

  environment.systemPackages = with pkgs; [
    #jetbrains.idea-ultimate
    unstable.jetbrains.idea-ultimate
    gitkraken
    insomnia
  ];
}
