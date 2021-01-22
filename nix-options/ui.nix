{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.gytix.ui;
  keybindingsStr = concatStringsSep "\n" (
    mapAttrsToList
      (hotkey: command:
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
    after = [ "graphical-session-pre.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    description = desc;
    serviceConfig = {
      Restart = "always";
      ExecStart = exec;
    };
  };
  mkOneshot = enabled: desc: exec: mkIf enabled (mkService enabled desc exec // { serviceConfig.Type = "oneshot"; });
in
{

  options = {
    gytix.ui.autorandr = daemonOption pkgs.autorandr;
    gytix.ui.polkit-ui = daemonOption pkgs.pkgs.pantheon.pantheon-agent-polkit;
    gytix.ui.sxhkd = daemonOption pkgs.sxhkd;

    gytix.ui.keybindings = mkOption {
      type = types.attrsOf (types.nullOr types.str);
      default = { };
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
    environment.etc.xprofile.text = ''
      systemctl --user stop graphical-session.target graphical-session-pre.target
      systemctl --user import-environment
      systemctl --user start autostart.target
    '';

    systemd.user.targets.autostart = {
      description = "Target to bind applications that should be started after VM";
      requires = [ "graphical-session-pre.target" ];
      bindsTo = [ "graphical-session.target" ];
    };

    systemd.user.services = {

      polkit-ui = mkService cfg.polkit-ui.enable
        "Polkit UI popup"
        "${cfg.polkit-ui.package}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";

      autorandr = mkOneshot cfg.autorandr.enable
        "Autorandr - automatic monitors management"
        "${cfg.autorandr.package}/bin/autorandr --change";

      sxhkd = mkService cfg.sxhkd.enable
        "Simple X hotkey daemon"
        "${cfg.sxhkd.package}/bin/sxhkd -c ${pkgs.writeText "sxhkd.conf" keybindingsStr}";

    };
  };
}
