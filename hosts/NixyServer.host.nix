{ config, lib, pkgs, ... }:

{


  fileSystems."/" = { device = "zroot/locker/os"; fsType = "zfs"; };
  fileSystems."/home" = { device = "zroot/locker/home"; fsType = "zfs"; };
  fileSystems."/nix/store" = { device = "zroot/store"; fsType = "zfs"; };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/8BCE-4FF4"; fsType = "vfat"; };

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" "tcp_bbr" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Rest of this file is tweaked/slimed down base.nix copy-paste
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "20.09";
  time.timeZone = lib.mkDefault "Europe/Vilnius";
  gytix.cachix.enable = true;

  systemd.network.enable = true;
  networking = {
    useDHCP = false;
    interfaces.enp3s0.useDHCP = true;
    firewall.allowPing = lib.mkDefault false;
    firewall.allowedTCPPorts = [ 3000 4200 8080 8081 8082 8083 ];


    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    nameservers = lib.mkDefault [ "1.1.1.1" "1.0.0.1" ];
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 20d";
    dates = "04:00";
  };

  boot = {
    # Imporved networking
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    kernel.sysctl."net.core.default_qdisc" = "fq";

    kernelParams = [ "quiet" "loglevel=3" ];
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.timeout = 2;
    tmpOnTmpfs = lib.mkDefault true;
  };

  services = {
    zfs.autoSnapshot.enable = true;
    zfs.autoScrub.enable = true;
    openssh.enable = lib.mkDefault true;
    openssh.passwordAuthentication = lib.mkDefault false;
    tlp.enable = lib.mkDefault true;
  };

  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
  };

  hardware.cpu.intel.updateMicrocode = true;
}
