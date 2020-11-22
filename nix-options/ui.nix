{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gytix.ui;
  keybindingsStr = concatStringsSep "\n" (
    mapAttrsToList (hotkey: command:
      optionalString (command != null) ''
        ${hotkey}
          ${command}
      ''
    )
    cfg.keybindings
  );
  daemonOption = pkg: {
    enable = mkEnableOption "Enable application on starup";
    package = mkOption {
      description = "Package which will be used";
      type = types.package;
      default = pkg;
    };
  };
  mkService = enabled: desc: exec: mkIf enabled {
    wantedBy = ["autostart.target"];
    description = desc;
    serviceConfig = {
      Restart = "always";
      ExecStart = exec;
    };
  };
  mkOneshot = enabled: desc: exec: mkIf enabled {
    wantedBy = ["autostart.target"];
    description = desc;
    serviceConfig = {
      Restart = "always";
      Type = "oneshot";
      ExecStart = exec;
    };
  };
in {

  options = {
    gytix.ui.autorandr = daemonOption pkgs.autorandr;
    gytix.ui.feh       = daemonOption pkgs.feh;
    gytix.ui.flameshot = daemonOption pkgs.flameshot;
    gytix.ui.nm-applet = daemonOption pkgs.networkmanagerapplet;
    gytix.ui.polkit-ui = daemonOption pkgs.pkgs.pantheon.pantheon-agent-polkit;
    gytix.ui.polybar   = daemonOption pkgs.polybarFull;
    gytix.ui.sxhkd     = daemonOption pkgs.sxhkd;
    gytix.ui.ulauncher = daemonOption pkgs.ulauncher;

    gytix.ui.keybindings = mkOption {
      type = types.attrsOf (types.nullOr types.str);
      default = {};
      description = "An attribute set that assigns hotkeys to commands.";
      example = literalExample ''
          {
          "super + shift + {r,c}" = "i3-msg {restart,reload}";
          "super + {s,w}"         = "i3-msg {stacking,tabbed}";
          }
      '';
    };

  };

  config = {
    systemd.user.targets.autostart = {
      description = "Target to bind applications that should be started after VM";
    };

    systemd.user.services = {
      polybar = mkService cfg.polybar.enable
        "Polybar - system status bar"
        "${cfg.polybar.package}/bin/polybar -c ${./polybar.conf} main";

      feh = mkOneshot cfg.feh.enable
        "Feh - sets desktop wallpaper"
        "${cfg.feh.package}/bin/feh --randomize --no-fehbg --bg-fill ${./Wallpapers}";

      ulauncher = mkService cfg.ulauncher.enable
        "Ulauncher - application launcher"
        "/run/current-system/sw/bin/execWithEnv ${cfg.ulauncher.package}/bin/ulauncher --hide-window";

      nm-applet = mkService cfg.nm-applet.enable
        "Network Manager Applet"
        "${cfg.nm-applet.package}/bin/nm-applet";


      flameshot = mkService cfg.flameshot.enable
        "Flameshot - desktop screenshot utility"
        "/run/current-system/sw/bin/execWithEnv ${cfg.flameshot.package}/bin/flameshot";

      polkit-ui = mkService cfg.polkit-ui.enable
        "Polkit UI popup"
        "${cfg.polkit-ui.package}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";

      autorandr = mkOneshot cfg.autorandr.enable
        "Autorandr - automatic monitors management"
        "/run/current-system/sw/bin/execWithEnv ${cfg.autorandr.package}/bin/autorandr --change";

      sxhkd = mkService cfg.sxhkd.enable
        "Simple X hotkey daemon"
        "/run/current-system/sw/bin/execWithEnv ${cfg.sxhkd.package}/bin/sxhkd -c ${pkgs.writeText "sxhkd.conf" keybindingsStr}";

    };
  };
}

