{ lib, pkgs, config, options, ... }:

with lib;
let
  modifier = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  bg-color = "#424242";
  inactive-bg-color = "#424242";
  text-color = "#4f97d7";
  inactive-text-color = "#676E7D";
  urgent-bg-color = "#E53935";

in
{

  services.network-manager-applet.enable = true;

  services.polybar.enable = true;
  services.polybar.script = "polybar";
  services.polybar.package = pkgs.g-polybar;

  services.flameshot.enable = true;

  services.random-background = {
    enable = true;
    interval = "1h";
    imageDirectory = "${../pkgs/Wallpapers}";
  };

  xsession.enable = true;
  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3 = {
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      floating.modifier = "Mod4";
      floating.border = 0;
      window.border = 0;
      focus.forceWrapping = false;
      focus.followMouse = false;
      fonts = [ "RobotoMono 9" ];
      terminal = "$TERMINAL";

      colors.focused = { border = bg-color; childBorder = bg-color; background = bg-color; text = text-color; indicator = "#00ff00"; };
      colors.unfocused = { border = inactive-bg-color; childBorder = inactive-bg-color; background = inactive-bg-color; text = inactive-text-color; indicator = "#00ff00"; };
      colors.focusedInactive = { border = inactive-bg-color; childBorder = inactive-bg-color; background = inactive-bg-color; text = inactive-text-color; indicator = "#00ff00"; };
      colors.urgent = { border = urgent-bg-color; childBorder = urgent-bg-color; background = urgent-bg-color; text = text-color; indicator = "#00ff00"; };

      menu = "${pkgs.g-rofi}/bin/rofi -show drun -modi drun";
      modes.resize = {
        Escape = "mode default";
        Return = "mode default";
        "${down}" = "resize grow height 10 px or 10 ppt";
        "${left}" = "resize shrink width 10 px or 10 ppt";
        "${right}" = "resize grow width 10 px or 10 ppt";
        "${up}" = "resize shrink height 10 px or 10 ppt";
      } ;

      bars = mkForce [];
      keybindings = with pkgs; mkOptionDefault {
        Print = "exec ${flameshot}/bin/flameshot gui";
        XF86AudioMute = "exec ${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        XF86AudioPlay = "exec ${playerctl}/bin/playerctl play";
        XF86AudioPause= "exec ${playerctl}/bin/playerctl pause";
        XF86AudioNext = "exec ${playerctl}/bin/playerctl next";
        XF86AudioPrev = "exec ${playerctl}/bin/playerctl prev";
        XF86AudioRaiseVolume = "exec ${pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ +5%";
        XF86AudioLowerVolume = "exec ${pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ -5%";
        XF86MonBrightnessUp = "exec ${xorg.xbacklight} -inc 20";
        XF86MonBrightnessDown = "exec ${xorg.xbacklight} -dec 20";

        "${modifier}+b" = "exec $BROWSER";
        "${modifier}+shift+b" = "exec $BROWSER --private-window";
        "${modifier}+z" = "exec ${autorandr}/bin/autorandr -c -f";

        #"${modifier}+t" = ''[class="scratchterm"] scratchpad show, move position center'';
        #"${modifier}+b" = ''[class="scratchbrowser"] scratchpad show, move position center '';

        #"${modifier}+Return" = "exec $TERMINAL";
        "${modifier}+q" = "kill";
        #"${modifier}+d" = "exec ${cfg.config.menu}";

        "${modifier}+${left}" = "focus left";
        "${modifier}+${down}" = "focus down";
        "${modifier}+${up}" = "focus up";
        "${modifier}+${right}" = "focus right";

        "${modifier}+Ctrl+${left}" = "move workspace to output left";
        "${modifier}+Ctrl+${down}" = "move workspace to output down";
        "${modifier}+Ctrl+${up}" = "move workspace to output up";
        "${modifier}+Ctrl+${right}" = "move workspace to output right";


        "${modifier}+Shift+${left}" = "move left";
        "${modifier}+Shift+${down}" = "move down";
        "${modifier}+Shift+${up}" = "move up";
        "${modifier}+Shift+${right}" = "move right";

        "${modifier}+c" = "split h";
        #"${modifier}+v" = "split v";
        #"${modifier}+f" = "fullscreen toggle";

        #"${modifier}+s" = "layout stacking";
        "${modifier}+t" = "layout tabbed";
        #"${modifier}+e" = "layout toggle split";

        #"${modifier}+Shift+space" = "floating toggle";
        #"${modifier}+space" = "focus mode_toggle";

        #"${modifier}+a" = "focus parent";

        #"${modifier}+Shift+minus" = "move scratchpad";
        #"${modifier}+minus" = "scratchpad show";

        #"${modifier}+1" = "workspace number 1";
        #"${modifier}+2" = "workspace number 2";
        #"${modifier}+3" = "workspace number 3";
        #"${modifier}+4" = "workspace number 4";
        #"${modifier}+5" = "workspace number 5";
        #"${modifier}+6" = "workspace number 6";
        #"${modifier}+7" = "workspace number 7";
        #"${modifier}+8" = "workspace number 8";
        #"${modifier}+9" = "workspace number 9";
        #"${modifier}+0" = "workspace number 10";

        #"${modifier}+Shift+1" = "move container to workspace number 1";
        #"${modifier}+Shift+2" = "move container to workspace number 2";
        #"${modifier}+Shift+3" = "move container to workspace number 3";
        #"${modifier}+Shift+4" = "move container to workspace number 4";
        #"${modifier}+Shift+5" = "move container to workspace number 5";
        #"${modifier}+Shift+6" = "move container to workspace number 6";
        #"${modifier}+Shift+7" = "move container to workspace number 7";
        #"${modifier}+Shift+8" = "move container to workspace number 8";
        #"${modifier}+Shift+9" = "move container to workspace number 9";
        #"${modifier}+Shift+0" = "move container to workspace number 10";

        #"${modifier}+Shift+c" = "reload";
        #"${modifier}+Shift+r" = "restart";
        #"${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

        #"${modifier}+r" = "mode resize";
      };
    };
  };
}
