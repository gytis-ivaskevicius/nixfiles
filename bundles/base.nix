{ config, pkgs, lib, ... }:
{
  imports = [
    #./unstable.nix
  ];

  #powerManagement.powertop.enable = true;
  console.keyMap = "us";
  fileSystems."/boot".label = "BOOT";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.autoOptimiseStore = true;
  nix.maxJobs = 16;
  system.stateVersion = "20.09";
  systemd.extraConfig = "DefaultMemoryAccounting=yes";
  time.timeZone = lib.mkDefault "Europe/Vilnius";

  system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

  networking = {
    firewall.allowPing = lib.mkDefault false;
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    nameservers = lib.mkDefault [ "1.1.1.1" "1.0.0.1" ];
    networkmanager.enable = lib.mkDefault true;
  };

  services.resolved = {
    enable = true;
    extraConfig = ''
       DNS=1.1.1.1 1.0.0.1
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 20d";
    dates = "04:00";
  };

  boot = {
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.timeout = 2;
    tmpOnTmpfs = lib.mkDefault true;
  };

  services = {
    avahi.enable = lib.mkDefault true;
    avahi.nssmdns = lib.mkDefault true;
    fstrim.enable = true;
    logind.killUserProcesses = lib.mkDefault true;
    openssh.enable = lib.mkDefault true;
    openssh.passwordAuthentication = lib.mkDefault false;
    printing.enable = lib.mkDefault true;
    tlp.enable = lib.mkDefault true;
  };

  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
  };

  hardware = {
    opengl = {
      enable = lib.mkDefault true;
      driSupport32Bit = true;
    };
    pulseaudio = {
      enable = lib.mkDefault true;
      support32Bit = true;
    };
    bluetooth.enable = lib.mkDefault false;
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
  };
}
