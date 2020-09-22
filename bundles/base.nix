{ config, pkgs, lib, ... }:
{
  imports = [
    ./unstable.nix
  ];

  #powerManagement.powertop.enable = true;
  console.keyMap = "us";
  fileSystems."/boot".label = "BOOT";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.autoOptimiseStore = true;
  nix.maxJobs = 16;
  system.stateVersion = "20.03";
  time.timeZone = "Europe/Vilnius";
  systemd.extraConfig = "DefaultMemoryAccounting=yes";

  system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

  networking = {
    enableIPv6 = false;
    firewall.allowPing = false;
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" ];
    networkmanager.enable = true;
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
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.timeout = 2;
    tmpOnTmpfs = true;
  };

  services = {
    avahi.enable = true;
    avahi.nssmdns = true;
    logind.killUserProcesses = true;
    openssh.enable = true;
    openssh.passwordAuthentication = false;
    printing.enable = true;
    tlp.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    bluetooth.enable = false;
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
  };
}
