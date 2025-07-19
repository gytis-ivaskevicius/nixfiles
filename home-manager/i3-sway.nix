{ wm, config, lib, pkgs, ... }:
with lib;
with pkgs;
let
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  bg-color = "#424242";
  inactive-bg-color = "#424242";
  text-color = "#4f97d7";
  inactive-text-color = "#676E7D";
  urgent-bg-color = "#E53935";
  isSway = wm == "sway";
in
{

  enable = true;
  package = pkgs.sway;
  config = {
    modifier = "Mod4";
    floating.modifier = "Mod4";
    floating.border = 0;
    window.border = 0;
    focus.forceWrapping = false;
    focus.followMouse = false;
    fonts = [ "RobotoMono 9" ];
    terminal = lib.getExe pkgs.alacritty;

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

		menu = pkgs.writeShellScript "rofi-menu.sh" ''
			monitor="$(swaymsg -t get_outputs | jq '[.[].focused] | index(true)')"
			${pkgs.g-rofi}/bin/rofi -show drun -modi drun -monitor "$monitor" $@
		'';

		#menu = "${pkgs.g-rofi}/bin/rofi -show drun -modi drun -m 1";
    modes.resize = {
      Escape = "mode default";
      Return = "mode default";
      ${down} = "resize grow height 10 px or 10 ppt";
      ${left} = "resize shrink width 10 px or 10 ppt";
      ${right} = "resize grow width 10 px or 10 ppt";
      ${up} = "resize shrink height 10 px or 10 ppt";
    };

    #    bars = mkForce [ ];
    bars = if isSway then [{ "command" = "${waybar}/bin/waybar"; }] else [ ];
    keybindings = mkOptionDefault (import ./keybindings.nix { inherit pkgs; });
  };
}
