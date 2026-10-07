{ pkgs, lib, ... }:
let
  windows-rdp = pkgs.makeDesktopItem {
    name = "windows-rdp";
    desktopName = "Windows VM";
    comment = "Connect to the Windows VM over RDP";
    icon = "preferences-system-windows";
    exec = lib.concatStringsSep " " [
      "${pkgs.freerdp}/bin/xfreerdp"
      "/v:127.0.0.1"
      "/port:3333"
      "/u:gytis"
      "/p:toor"
      "/cert:ignore"
      "/w:2560"
      "/h:1067"
      "/smart-sizing"
      "+clipboard"
      "/sound"
      "/microphone"
      "+auto-reconnect"
    ];
    categories = [ "Utility" "RemoteAccess" ];
  };
in
{
  environment.systemPackages = with pkgs; [ bc freerdp windows-rdp ];



  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      windows = {
        hostname = "winvm";
        autoStart = true;
        image = "dockurr/windows";
        volumes = [
          "/mnt/windows:/shared"
          "/home/docker/windows/data:/storage"
          "/etc/nixos/windows/:/oem"
        ];
        ports = [ "8000:8006" "3333:3389" ];
        environment = {
          VERSION = "2025";
          USERNAME = "gytis";
          PASSWORD = "toor";
          DISK_SIZE = "128G";
          RAM_SIZE = "8G";
          CPU_CORES = "8";
          ARGUMENTS = "-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time";
        };
        extraOptions =
          [ "--cap-add=NET_ADMIN" "--device=/dev/kvm" "--stop-timeout=120" ];
      };
    };
  };

}

