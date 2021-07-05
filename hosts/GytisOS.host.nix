{ config, builtins, lib, pkgs, modulesPath, ... }:

{

  boot.kernelParams = [ "idle=nomwait" "processor.max_cstate=5" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];

  fileSystems."/" = { device = "zroot/locker/os"; fsType = "zfs"; };
  fileSystems."/home" = { device = "zroot/locker/home"; fsType = "zfs"; };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/F794-3014"; fsType = "vfat"; };
  fileSystems."/nix" = { device = "zroot/locker/nix"; fsType = "zfs"; };

  environment.systemPackages = [ pkgs.chromium ];

  services.tailscale.enable = true;

  environment.shellAliases = {
    vv = "${pkgs.neovim-unwrapped}/bin/nvim";
  };
}
