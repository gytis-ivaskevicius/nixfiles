{ config, pkgs, lib, ... }:
{
  imports = [ ../base-systemd/applicationsTarget.nix ];

  environment.systemPackages = [ pkgs.ulauncher ];

  systemd.user.services.ulauncher = {
    description = "Ulauncher";
    wantedBy = ["applications.target"];
    script = ''unset __NIXOS_SET_ENVIRONMENT_DONE; source /etc/profile; exec "${pkgs.ulauncher}/bin/ulauncher" '';
    serviceConfig = {
      Restart = "always";
#      ExecStart = "${pkgs.ulauncher}/bin/ulauncher";
       
    };
  };

}
