{ config, pkgs, lib, ... }:


let
  execWithEnv = pkgs.writeScriptBin "execWithEnv" ''
    #!${pkgs.stdenv.shell}

    unset __NIXOS_SET_ENVIRONMENT_DONE
    source /etc/profile
    exec "$@"
  '';
  polybar = pkgs.polybar.override {
    i3GapsSupport = true;
    alsaSupport   = true;
  };
  systemd-common = {
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
    };
  };
in {

  systemd.user.services.polybar = {
    description = "Polybar system status bar";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${polybar}/bin/polybar -c ${./polybar.conf} main";
    };
  };

  systemd.user.services.feh = {
    description = "Feh";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.feh}/bin/feh --randomize --no-fehbg --bg-fill ${./Wallpapers}";
    };
  };

  environment.etc = {
    "xdg/dunst/dunstrc".source = ./dunst.conf;
  };

  systemd.user.services.ulauncher = {
    description = "Ulauncher";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.ulauncher}/bin/ulauncher --hide-window";
    };
  };

  systemd.user.targets.autostart = {
    description = "Target to bind applications that should be started after VM";
  };

  systemd.user.services.nm-applet = {
    description = "Network Manager Applet";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    };
  };

  systemd.user.services.flameshot = {
    description = "Flameshot";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.flameshot}/bin/flameshot";
    };
  };

  systemd.user.services.polkit-ui = {
    description = "Polkit UI popup";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
    };
  };

  systemd.user.services.autorandr = {
    description = "Autorandr execution hook";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.autorandr}/bin/autorandr --change";
    };
  };

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
