{ config, builtins, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      ../bundles/apps.nix
      ../bundles/base.nix
      ../bundles/clean_home.nix
      ../bundles/dev.nix
      ../bundles/i3rice.nix
      ../bundles/cli
      ../personal.nix
(modulesPath + "/installer/scan/not-detected.nix")
    ];

    #nixpkgs.overlays = [ (import ../pkgs) ];

    environment.systemPackages = with pkgs; [

    ];
    nix.package = pkgs.nixUnstable;
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';


  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d6eeba95-50d5-4517-8c9f-bc38ed88e73b";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/DE06-8285";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
