{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd/autostart-systemd.nix ];

  environment.systemPackages = [ pkgs.ulauncher ];

  systemd.user.services.ulauncher = {
    description = "Ulauncher";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.ulauncher}/bin/ulauncher --hide-window";
    };
  };

}
