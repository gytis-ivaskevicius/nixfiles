{ config, builtins, lib, pkgs, modulesPath, ... }:

{

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

  environment.systemPackages = with pkgs; [
    tio
  ];

  networking.extraHosts = ''
  '';

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  #"processor.max_cstate=5"
  boot.kernelParams = [ "idle=nomwait" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];

  fileSystems."/" = { device = "zroot/locker/os"; fsType = "zfs"; };
  fileSystems."/home" = { device = "zroot/locker/home"; fsType = "zfs"; };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/F794-3014"; fsType = "vfat"; };
  fileSystems."/nix" = { device = "zroot/locker/nix"; fsType = "zfs"; };

}
