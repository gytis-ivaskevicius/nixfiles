{ config, builtins, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./base.nix
    ./cli.nix
    ./cli-extras.nix
    ./sway.nix
  ];

  services.gnome3.gnome-keyring.enable = true;
  #services.tailscale.enable = true;
  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "9bee8941b5c7428a" "12ac4a1e710088c5" ];

  home-manager.users.gytis = import ../home-manager/sway.nix;
  users.extraUsers.gytis = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Gytis Ivaskevicius";
    extraGroups = [ "audio" "video" "dialout" "adbusers" "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "toor";
  };

  environment.systemPackages = with pkgs; [ ];

  networking.extraHosts = ''
  '';

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = { device = "/dev/disk/by-uuid/e60905dc-aadf-4c1b-b78f-51c5bceb91c4"; fsType = "f2fs"; };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/F0D4-8A70"; fsType = "vfat"; };

}
