{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd ];

  environment.systemPackages = [
    pkgs.feh
  ];

  systemd.user.services.feh = {
    description = "Feh";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.feh}/bin/feh --randomize --no-fehbg --bg-fill ${./Wallpapers}";
    };
  };

}
