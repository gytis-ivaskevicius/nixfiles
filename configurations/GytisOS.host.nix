{ config, builtins, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./base.nix
    ./dev.nix
    #./xorg.nix
    ./cli.nix
    ./cli-extras.nix
  ];

  services.gnome3.gnome-keyring.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest; # Default value is 'pkgs.linuxPackages'
  #hardware.bluetooth.enable = true;                  # Default value is 'false'
  services.tailscale.enable = true;
  services.zerotierone.enable = true; # Default value is 'false'
  services.zerotierone.joinNetworks = [ "9bee8941b5c7428a" "12ac4a1e710088c5" ]; # Default value is '[]'
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.windowManager.i3.enable = true;
  programs.sway.enable = true;


  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet)
    #pwms.enable = true;

    # You probably won't benefit from the extra codecs unless you headphones that don't support AAC
    # but it's a nice example for extra config
    #pwms.bluezMonitorConfig = {
    #  properties.bluez5 = {
    #    msbc-support = true;
    #    sbc-xq-support = true;
    #  };
    #  rules = [
    #    {
    #      matches = [ {device.name = "~bluez_card.*";} ];
    #      actions = { update-props = {}; };
    #    }
    #    {
    #      matches = [
    #        { device.name = "~bluez_input.*"; }
    #        { device.name = "~bluez_output.*"; }
    #      ];
    #      actions = { update-props = {}; };
    #    }
    #  ];
    #};

    # pwms has more config files, refer to the pipewire-media-session module added in #110615 for them
  };


  home-manager.users.gytis = import ../home-manager;
  users.extraUsers.gytis = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Gytis Ivaskevicius";
    extraGroups = [ "audio" "video" "dialout" "adbusers" "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "toor";
  };

  environment.systemPackages = with pkgs; [
    wofi
    ion
    gnupg
    chromium
    lightcord
  ];

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  networking.extraHosts = ''
  '';

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" = { device = "zroot/locker/os"; fsType = "zfs"; };
  fileSystems."/home" = { device = "zroot/locker/home"; fsType = "zfs"; };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/F794-3014"; fsType = "vfat"; };
  fileSystems."/nix" = { device = "zroot/locker/nix"; fsType = "zfs"; };

}
