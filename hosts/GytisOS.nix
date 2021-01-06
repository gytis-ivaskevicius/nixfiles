{ config, builtins, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../bundles/apps.nix
    ../bundles/base.nix
    ../bundles/clean_home.nix
    ../bundles/dev.nix
    ../bundles/i3rice.nix
    ../bundles/cli
    ../bundles/cachix.nix
  ];

   nixpkgs.config.allowBroken = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;   # Default value is 'pkgs.linuxPackages'
  #hardware.bluetooth.enable = true;                  # Default value is 'false'
  #services.openssh.passwordAuthentication = false;   # Default value is 'false'
  services.zerotierone.enable = true;                # Default value is 'false'
  services.zerotierone.joinNetworks = [ "9bee8941b5c7428a" ];           # Default value is '[]'
  #time.timeZone = "Europe/Vilnius";                  # Default value is 'Europe/Vilnius'
  #networking.enableIPv6 = false;                     # Default value is 'true'

  users.extraUsers.gytis = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Gytis Ivaskevicius";
    extraGroups = [ "audio" "dialout" "adbusers" "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "toor";
  };

  environment.systemPackages = with pkgs; [
    tdesktop
    rustup
    cargo
    grpcui
    woeusb
  ];

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  networking.extraHosts = ''
  '';

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d6eeba95-50d5-4517-8c9f-bc38ed88e73b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DE06-8285";
    fsType = "vfat";
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
