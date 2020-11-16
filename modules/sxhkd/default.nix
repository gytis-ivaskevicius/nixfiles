{ pkgs, ... }:
{
  imports = [
    ../autostart-systemd
  ];
  environment.systemPackages = with pkgs; [ sxhkd i3lock-pixeled g-rofi ];

  systemd.user.services.sxhkd = {
    description = "Simple X hotkey daemon";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.sxhkd}/bin/sxhkd -c ${./sxhkd.conf}";
    };
  };

}
