{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [ bc freerdp ];



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

