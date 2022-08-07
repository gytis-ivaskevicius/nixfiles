{ wm, config, lib, pkgs, ... }:
with lib;
with pkgs;
let
  autotiling = writeShellScript "i3-autotiling.sh" ''
    #!/usr/bin/env bash

    REGEX="([0-9]+)x([0-9]+)"

    update_split(){
        OUTPUT="$(${xdotool}/bin/xdotool getwindowfocus getwindowgeometry)"

        if [[ $OUTPUT =~ $REGEX ]]
        then
            WIDTH="''${BASH_REMATCH[1]}"
            HEIGHT="''${BASH_REMATCH[2]}"
            if [ $WIDTH -gt $HEIGHT ];
            then
                ${config.xsession.windowManager.i3.package}/bin/i3-msg "split h"
            else
                ${config.xsession.windowManager.i3.package}/bin/i3-msg "split v"
            fi
        fi
    }

    while read -r line
    do
        LAYOUT="$(${config.xsession.windowManager.i3.package}/bin/i3-msg -t get_tree | ${jq}/bin/jq -r 'recurse(.nodes[]; .nodes != null) | select(.nodes[].focused).layout')"
        if [ "$LAYOUT" = "splitv" ] || [ "$LAYOUT" = "splith" ]; then
            update_split
        fi
    done < <(xprop -spy -root _NET_ACTIVE_WINDOW)
  '';
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  bg-color = "#424242";
  inactive-bg-color = "#424242";
  text-color = "#4f97d7";
  inactive-text-color = "#676E7D";
  urgent-bg-color = "#E53935";
  isI3 = wm == "i3";
  isSway = wm == "sway";
in
{

  enable = true;
  extraConfig = mkIf isI3 ''
    exec --no-startup-id ${autotiling}
    set $movemouse "sh -c 'eval `${pkgs.xdotool}/bin/xdotool getactivewindow getwindowgeometry --shell`; ${pkgs.xdotool}/bin/xdotool mousemove $((X+WIDTH/2)) $((Y+HEIGHT/2))'"
  '';
  package = if isI3 then pkgs.i3-gaps else pkgs.sway;
  config = {
    modifier = "Mod4";
    floating.modifier = "Mod4";
    floating.border = 0;
    window.border = 0;
    focus.forceWrapping = false;
    focus.followMouse = false;
    fonts = [ "RobotoMono 9" ];
    terminal = lib.getExe pkgs.alacritty;
    startup = mkIf isI3 [
      { command = "systemctl --user restart polybar"; always = true; notification = false; }
      { command = "autorandr -c"; always = true; notification = false; }
      #{ command = "waybar"; always = true; notification = false; }
    ];

    colors.focused = {
      border = bg-color;
      childBorder = bg-color;
      background = bg-color;
      text = text-color;
      indicator = "#00ff00";
    };
    colors.unfocused = {
      border = inactive-bg-color;
      childBorder = inactive-bg-color;
      background = inactive-bg-color;
      text = inactive-text-color;
      indicator = "#00ff00";
    };
    colors.focusedInactive = {
      border = inactive-bg-color;
      childBorder = inactive-bg-color;
      background = inactive-bg-color;
      text = inactive-text-color;
      indicator = "#00ff00";
    };
    colors.urgent = {
      border = urgent-bg-color;
      childBorder = urgent-bg-color;
      background = urgent-bg-color;
      text = text-color;
      indicator = "#00ff00";
    };

    menu = "${pkgs.g-rofi}/bin/rofi -show drun -modi drun";
    modes.resize = {
      Escape = "mode default";
      Return = "mode default";
      ${down} = "resize grow height 10 px or 10 ppt";
      ${left} = "resize shrink width 10 px or 10 ppt";
      ${right} = "resize grow width 10 px or 10 ppt";
      ${up} = "resize shrink height 10 px or 10 ppt";
    };

    #    bars = mkForce [ ];
    bars =
      if isSway then [{
        "command" = "${waybar}/bin/waybar";
      }] else [ ];
    keybindings = mkOptionDefault (import ./keybindings.nix { inherit pkgs; });
  };
}
