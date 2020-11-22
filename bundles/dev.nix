
{ config, pkgs, ... }:

{
  imports = [
    ../modules/java
    ../modules/node
  ];

  environment.systemPackages = with pkgs; [
    docker_compose
    gitkraken
    insomnia
    jetbrains.idea-ultimate
  ];

  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    enableNvidia = true;
    enableOnBoot = false;
    liveRestore = false;
  };

  virtualisation.virtualbox = {
    host.enable = true;

    # Takes quite a while to compile. It adds support for:
    # USB 2.0/3.0 devices, VirtualBox RDP, disk encryption, NVMe and PXE boot for Intel cards
    #host.enableExtensionPack = true;

    # VirtualBox Guest additions
    #virtualisation.virtualbox.guest.enable = true;
  };


}
