{ config, pkgs, lib, ... }:

{
  #virtualisation.podman.enable = true;

  environment.systemPackages = with pkgs; [
    gradle
    insomnia
    #jetbrains.idea-ultimate
    maven
    #podman-compose
    nomad
    wander
    terraform
    terragrunt
    awscli2
    kubectl
    kubernetes-helm
    k9s
  ];

  ## Docker
  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    #enableNvidia = true;
    enableOnBoot = false;
    liveRestore = false;
  };

  ## VirtualBox
  virtualisation.virtualbox = {
    host.enable = false;

    # Takes quite a while to compile. It adds support for:
    # USB 2.0/3.0 devices, VirtualBox RDP, disk encryption, NVMe and PXE boot for Intel cards
    host.enableExtensionPack = true;

    # VirtualBox Guest additions
    #virtualisation.virtualbox.guest.enable = true;
  };

  ### Java
  gytix.java.additionalPackages = {
    #inherit (pkgs) jdk11 jdk8;
  };
  programs.java.enable = true;
  programs.java.package = pkgs.jdk;

  ### Node
  programs.npm.enable = true;
  programs.npm.package = pkgs.nodejs;
  gytix.node.additionalPackages = {
    #inherit (pkgs) nodejs-16_x;
  };
}
