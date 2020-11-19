{ config, pkgs, lib, ... }:


let
  execWithEnv = pkgs.writeScriptBin "execWithEnv" ''
    #!${pkgs.stdenv.shell}

    unset __NIXOS_SET_ENVIRONMENT_DONE
    source /etc/profile
    exec "$@"
  '';
  sc-base = {
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
    };
  };
in {
  environment.systemPackages = with pkgs; [
    sxhkd
    i3lock-pixeled
    g-rofi
    execWithEnv
  ];

  environment.etc = {
    "xdg/dunst/dunstrc".source = ./dunst.conf;
  };



  systemd.user.targets.autostart = {
    description = "Target to bind applications that should be started after VM";
  };

  systemd.user.services = {
    polybar = (sc-base // {
      description = "Polybar system status bar";
      serviceConfig.ExecStart = "${pkgs.polybarFull}/bin/polybar -c ${./polybar.conf} main";
    });

    feh = (sc-base // {
      description = "Feh";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.feh}/bin/feh --randomize --no-fehbg --bg-fill ${./Wallpapers}";
      };
    });

    ulauncher = (sc-base // {
      description = "Ulauncher";
      serviceConfig.ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.ulauncher}/bin/ulauncher --hide-window";
    });

    nm-applet = (sc-base // {
      description = "Network Manager Applet";
      serviceConfig.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    });

    flameshot = (sc-base // {
      description = "Flameshot";
      serviceConfig.ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.flameshot}/bin/flameshot";
    });

    polkit-ui = (sc-base // {
      description = "Polkit UI popup";
      serviceConfig.ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
    });

    autorandr = (sc-base // {
      description = "Autorandr execution hook";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.autorandr}/bin/autorandr --change";
      };
    });

    sxhkd = (sc-base // {
      description = "Simple X hotkey daemon";
      serviceConfig.ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.sxhkd}/bin/sxhkd -c ${./sxhkd.conf}";
    });
  };
}
