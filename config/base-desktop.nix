{ config, pkgs, lib, ... }:
{
  #powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  console.keyMap = "us";
  fileSystems."/boot".label = "BOOT";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "21.11";
  time.timeZone = "Europe/Vilnius";

  gytix.cachix.enable = true;
  gytix.cleanHome.enable = true;

  systemd.tmpfiles.rules = [
    "L+ /lib64/ld-linux-x86-64.so.2 - - - - ${pkgs.glibc}/lib64/ld-linux-x86-64.so.2"
  ];

  # Limits start limit burst to 1sec instead of 5 since it was causing issues with rapid logout/login and units restart
  systemd.user.extraConfig = ''
    DefaultStartLimitBurst=1
  '';

  networking = {
    #firewall.enable = false;
    #firewall.allowedTCPPorts = [ 8080 9090 ];
    firewall.allowPing = false;
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    nameservers = [ "192.168.30.11" "192.168.30.12" ];
    useDHCP = false;
    networkmanager.enable = true;
  };

  environment.systemPackages = [ pkgs.bluez ];

  #services.resolved = {
  #  enable = true;
  #  extraConfig = ''
  #    DNS=1.1.1.1 1.0.0.1 127.0.0.1:12299 127.0.0.1:12298
  #  '';
  #};

  programs.ssh.startAgent = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 40d";
    dates = "weekly";
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
    #zfs.enableUnstable = true;
    kernelParams = [ "quiet" "loglevel=3" ];
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.timeout = 2;
    tmpOnTmpfs = true;
  };

  services = {
    zfs.autoSnapshot.enable = true;
    zfs.autoScrub.enable = true;
    openssh.enable = true;
    openssh.passwordAuthentication = false;
    printing.enable = true;
    tlp.enable = true;
  };
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
  '';

  zramSwap.enable = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = [ pkgs.nerdfonts ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    opengl = {
      enable = lib.mkDefault true;
      driSupport32Bit = config.hardware.opengl.enable;
      #extraPackages = with pkgs; [
      #  rocm-opencl-icd
      #  rocm-opencl-runtime
      #  amdvlk
      #];
      #extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };
    cpu.amd.updateMicrocode = true;
    #cpu.intel.updateMicrocode = true;
  };
}
