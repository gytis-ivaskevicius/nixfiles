{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker_compose
    gitkraken
    gradle
    insomnia
    unstable.jetbrains.idea-ultimate
    maven
    visualvm
  ];

  ### Docker
  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    #enableNvidia = true;
    enableOnBoot = false;
    liveRestore = false;
  };

  ### VirtualBox
  #  virtualisation.virtualbox = {
  #    host.enable = true;

  # Takes quite a while to compile. It adds support for:
  # USB 2.0/3.0 devices, VirtualBox RDP, disk encryption, NVMe and PXE boot for Intel cards
  #host.enableExtensionPack = true;

  # VirtualBox Guest additions
  #virtualisation.virtualbox.guest.enable = true;
  #  };

  ### Java
  gytix.java.additionalPackages = with pkgs; {
    "8" = jdk8;
    "11" = jdk11;
    "14" = jdk14;
    "15" = unstable.jdk15;
  };
  programs.java.enable = true;
  programs.java.package = pkgs.unstable.jdk15;

  ### Node
  programs.npm.enable = true;
  programs.npm.package = pkgs.nodejs-14_x;
  gytix.node.additionalPackages = {
    "10" = pkgs.nodejs-10_x;
    "14" = pkgs.nodejs-14_x;
  };
}
