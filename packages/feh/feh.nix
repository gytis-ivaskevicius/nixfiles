{ config, pkgs, lib, ... }:
{
  imports = [ ../base-systemd/applicationsTarget.nix ];

  environment.systemPackages = [
    pkgs.feh
  ];

  systemd.user.services.feh = {
    description = "Feh";
    wantedBy = ["applications.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c '/usr/bin/feh --randomize --bg-fill $HOME/Pictures/wallpaper/*'";
    };
  };

}
