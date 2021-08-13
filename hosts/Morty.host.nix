{ config, builtins, lib, pkgs, modulesPath, ... }:

{


  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" "rtsx_usb_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e60905dc-aadf-4c1b-b78f-51c5bceb91c4";
    options = [ "compress_algorithm=lz4" ];
    fsType = "f2fs";
  };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/F0D4-8A70"; fsType = "vfat"; };

}
