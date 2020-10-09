{ config, pkgs, lib, ... }:
let polybar = pkgs.polybar.override {
  i3GapsSupport = true;
  alsaSupport   = true;
};
in {
  imports = [ ../autostart-systemd ];

  environment.systemPackages = [
    polybar
  ];

  systemd.user.services.polybar = {
    description = "Polybar system status bar";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${polybar}/bin/polybar -c ${./polybar.conf} main";
    };
  };

}
