{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [ bc freerdp3 ];

  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      #qemuRunAsRoot = false;
      #onBoot = "ignore";
      #allowedBridges = [
      #  "virbr0"
      #  "virbr1"
      #  "virbr0-nic"
      #  "docker0"
      #];
    };

    spiceUSBRedirection.enable = true;
  };

  users.groups.libvirt = { };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      windows = {
        hostname = "winvm";
        autoStart = true;
        image = "dockurr/windows";
        volumes = [
          "/mnt/shared:/shared"
          "/home/docker/windows/data:/storage"
          "/etc/nixos/scripts:/oem"
        ];
        ports = [ "8006:8006" "3389:3389" ];
        environment = {
          VERSION = "win11e";
          USERNAME = "gytis";
          PASSWORD = "toor";
          DISK_SIZE = "128G";
          RAM_SIZE = "16G";
          CPU_CORES = "8";
        };
        extraOptions =
          [ "--cap-add=NET_ADMIN" "--device=/dev/kvm" "--stop-timeout=120" ];
      };
      windows-v2 = {
        hostname = "winvm-v2";
        autoStart = false;
        image = "dockurr/windows";
        volumes = [
          "/mnt/windows:/shared"
          "/home/docker/windows-v2/data:/storage"
          "/etc/nixos/windows-v2/:/oem"
        ];
        ports = [ "8000:8006" "3333:3389" ];
        environment = {
          VERSION = "win11e";
          USERNAME = "gytis";
          PASSWORD = "toor";
          DISK_SIZE = "128G";
          RAM_SIZE = "16G";
          CPU_CORES = "8";
        };
        extraOptions =
          [ "--cap-add=NET_ADMIN" "--device=/dev/kvm" "--stop-timeout=120" ];
      };
    };
  };

}
