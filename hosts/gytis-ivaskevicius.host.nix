{ config, builtins, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./work/modules.nix
    ./work/i3rice.nix
  ];
  programs.ssh.startAgent = true;


  hardware.bluetooth.enable = true;
  environment.variables = {
    BROWSER = "brave";
    TERMINAL = "alacritty";
  };

  environment.systemPackages = with pkgs; [
    brave
    cinnamon.nemo
    discord
    firefox
    g-alacritty
    gnome3.eog
    pavucontrol
    python
    tdesktop
    vlc
    xdg-utils # Multiple packages depend on xdg-open at runtime. This includes Discord and JetBrains
  ];


  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = { device = "/dev/disk/by-uuid/f578dbd2-d5a4-405b-aca5-530285ab1403"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/1C61-078B"; fsType = "vfat"; };


  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";


  services.tailscale.enable = true;


  #  networking.extraHosts = ''
  #    10.232.254.232  ozas.vrm.lt
  #    10.232.254.232  nsis2pldb.vrm.lt
  #    10.232.254.232  nsis2appdev.vrm.lt
  #  '';
}
