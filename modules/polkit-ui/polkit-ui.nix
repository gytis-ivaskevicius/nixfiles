{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd/autostart-systemd.nix ];
    environment.systemPackages = [ pkgs.pantheon.pantheon-agent-polkit ];


  systemd.user.services.polkit-ui = {
    description = "Polkit UI popup";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.pantheon-agent-polkit";
    };
  };

}
