{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd/autostart-systemd.nix ];

  environment.systemPackages = [ pkgs.ulauncher ];

  systemd.user.services.ulauncher = {
    description = "Ulauncher";
    wantedBy = ["autostart.target"];
    script = ''unset __NIXOS_SET_ENVIRONMENT_DONE; source /etc/profile; exec "${pkgs.ulauncher}/bin/ulauncher" '';
    serviceConfig = {
      Restart = "always";
#      ExecStart = "${pkgs.ulauncher}/bin/ulauncher";
       
    };
  };

}
