{ config, lib, pkgs, ... }:
{
  virtualisation.virtualbox.host = {
    enable = true;
    # Takes quite a while to compile. It adds support for:
    # USB 2.0/3.0 devices, VirtualBox RDP, disk encryption, NVMe and PXE boot for Intel cards
    #enableExtensionPack = true;
  };

  # VirtualBox Guest additions
  #virtualisation.virtualbox.guest.enable = true;

}

