{ config, pkgs, lib, ... }:
{
  #powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  console.keyMap = "us";
  fileSystems."/boot".label = "BOOT";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.autoOptimiseStore = true;
  system.stateVersion = "20.09";
  systemd.extraConfig = "DefaultMemoryAccounting=yes";
  time.timeZone = lib.mkDefault "Europe/Vilnius";

  gytix.cachix.enable = true;
  gytix.cleanHome.enable = true;

  system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

  # Limits start limit burst to 1sec instead of 5 since it was causing issues with rapid logout/login and units restart
  systemd.user.extraConfig = ''
    DefaultStartLimitBurst=1
  '';

  networking = {
    firewall.allowPing = lib.mkDefault false;
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    nameservers = lib.mkDefault [ "1.1.1.1" "1.0.0.1" ];
    useDHCP = false;
    interfaces."enp39s0".useDHCP = true;
    useNetworkd = true;
  };

  systemd.network.enable = true;
  environment.systemPackages = [pkgs.bluez];

  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=1.1.1.1 1.0.0.1 127.0.0.1:12299 127.0.0.1:12298
    '';
  };

  programs.ssh.startAgent = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 20d";
    dates = "04:00";
  };

  boot = {
    # Imporved networking
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    kernel.sysctl."net.core.default_qdisc" = "fq";

    kernel.sysctl = {
      "vm.swappiness" = 5;
      "fs.inotify.max_user_watches" = 524288;
    };
    zfs.enableUnstable = true;
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
    printing.enable = lib.mkDefault true;
    tlp.enable = lib.mkDefault true;
  };
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
  '';

  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      nerdfonts
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    opengl = {
      enable = lib.mkDefault true;
      driSupport32Bit = config.hardware.opengl.enable;
      extraPackages = with pkgs; [ amdvlk ];
      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };
    #pulseaudio = {
    #  enable = lib.mkDefault true;
    #  support32Bit = config.hardware.pulseaudio.enable;
    #};
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
  };
}
