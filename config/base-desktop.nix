{ config, pkgs, lib, ... }: {
  imports = [
    ./steam.nix
  ];
  #powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.auto-optimise-store = false;
  system.stateVersion = "26.05";
  time.timeZone = "Europe/Vilnius";

  #gytix.cachix.enable = true;
  gytix.cleanHome.enable = true;

  systemd.tmpfiles.rules = [
    "L+ /lib64/ld-linux-x86-64.so.2 - - - - ${pkgs.glibc}/lib64/ld-linux-x86-64.so.2"
    "L+    /opt/rocm   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # Limits start limit burst to 1sec instead of 5 since it was causing issues with rapid logout/login and units restart
  systemd.user.extraConfig = ''
    DefaultStartLimitBurst=1
  '';

  networking = {
    #firewall.enable = false;
    #firewall.allowedTCPPorts = [ 8080 9090 ];
    firewall.allowPing = false;
    hostId = builtins.substring 0 8
      (builtins.hashString "md5" config.networking.hostName);
    nameservers = [ "192.168.30.11" "192.168.30.12" ];
    useDHCP = false;
    networkmanager.enable = true;
  };


  services.resolved = {
    enable = true;
    settings.Resolve.DNS = "1.1.1.1 1.0.0.1";
  };

  programs.ssh.startAgent = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 40d";
    dates = "weekly";
  };


  boot = {
    # Imporved networking
    kernelModules = [ "tcp_bbr" "amdgpu" ];
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    kernel.sysctl."net.core.default_qdisc" = "fq";

    kernel.sysctl = {
      "vm.swappiness" = 5;
      "fs.inotify.max_user_watches" = 524288;
    };
    #zfs.enableUnstable = true;
    #kernelParams = [ "quiet" "loglevel=3" ];
    tmp.cleanOnBoot = true;
    loader.systemd-boot.enable = true;
    initrd.systemd.enable = true;
    initrd.availableKernelModules = [ "amdgpu" ];
    initrd.kernelModules = [ "amdgpu" ];
    loader.timeout = 2;
    tmp.useTmpfs = true;
  };

  services = {
    fwupd.enable = true;
    dbus.packages = with pkgs; [ dconf ];
    zfs.autoSnapshot.enable = true;
    zfs.autoScrub.enable = true;
    openssh.enable = true;
    openssh.settings.PasswordAuthentication = false;
    printing.enable = true;
  };

  zramSwap.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    #packages = [pkgs.nerdfonts];
  };

  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.gnupg.agent.enable = true;

  #hardware.amdgpu.amdvlk.enable = true;
  #hardware.amdgpu.amdvlk.support32Bit.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    amdgpu = {
      initrd.enable = true;
    };
    graphics = {
      enable =  true;
      enable32Bit = true;
      extraPackages = with pkgs; [
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        mesa.drivers
      ];
    };
    cpu.amd.updateMicrocode = true;
    #cpu.intel.updateMicrocode = true;
  };
}
