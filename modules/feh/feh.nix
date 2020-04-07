{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd/autostart-systemd.nix ];

  environment.systemPackages = [
    pkgs.feh
  ];

  systemd.user.services.feh = {
    description = "Feh";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.feh}/bin/feh --randomize --bg-fill $HOME/Pictures/wallpaper/*";
    };
  };

}
