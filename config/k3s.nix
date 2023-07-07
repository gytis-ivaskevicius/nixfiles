{ config, lib, pkgs, ... }:
{
  services.k3s.enable = true;
  services.k3s.extraFlags = toString [
    "--disable metrics-server"
    "--disable traefik"
  ];

  #boot.kernel.sysctl."net.ipv6.conf.enp1s0f0.accept_ra" = "2";

  environment.systemPackages = [ pkgs.iptables ];
  systemd.services.k3s.path = [ pkgs.ipset ];
}
