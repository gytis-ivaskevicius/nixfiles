{ config, pkgs, lib, ... }: {
  imports = [
    ./steam.nix
  ];
  #powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.auto-optimise-store = false;
  system.stateVersion = "24.11";
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


  environment.systemPackages = with pkgs; [

    pkgs.lact
    bluez
    btop-rocm
    clinfo
    lact
    libaom
    libva-utils
    libvmaf
    mesa
    nvtopPackages.amd
    protonplus
    protontricks
    svt-av1
    rocmPackages.clr.icd
    vulkan-extension-layer
    vulkan-tools
    vulkan-validation-layers
    (pkgs.writeShellScriptBin "amdvlk-run" ''
      export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json"
      exec "$@"
    '')
  ];

  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=1.1.1.1 1.0.0.1
    '';
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
    tlp.enable = true;
  };
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
  '';

  zramSwap.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    #packages = [pkgs.nerdfonts];
  };

  services.upower.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    environment = {
      WAYLAND_DISPLAY = "wayland-1";
      DISPLAY = ":0";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  xdg.portal = {
    enable = true;
    #extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    #config = {
    #  common = {
    #    default = "wlr";
    #  };
    #};
  };

  services.flatpak.enable = true;

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
