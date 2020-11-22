
{ config, pkgs, ... }:

{
  imports = [
    ../modules/compton
    ../modules/i3
    ../modules/styling
  ];

  gytix.ui.autorandr.enable = true;
  gytix.ui.feh.enable = true;
  gytix.ui.flameshot.enable = true;
  gytix.ui.nm-applet.enable = true;
  gytix.ui.polkit-ui.enable = true;
  gytix.ui.polybar.enable = true;
  gytix.ui.sxhkd.enable = true;
  gytix.ui.ulauncher.enable = true;

  gytix.ui.keybindings = {
    "Print" = "flameshot gui";
    "XF86AudioMute" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
    "XF86Audio{Play,Pause,Next,Prev}" = "playerctl {play,pause,next,previous}";
    "XF86Audio{RaiseVolume,LowerVolume}" = "pactl set-sink-volume @DEFAULT_SINK@ {+5%,-5%}";
    "XF86MonBrightness{Up,Down}" = "xbacklight -{inc,dec} 20";
    "alt + shift + l" = "i3lock-pixeled";
    "super + Return" = "$TERMINAL";
    "super + b" = "$BROWSER";
    "super + d" = "rofi -show drun -modi drun";
    "super + g" = "google-chrome-stable";
    "super + i" = "idea-ultimate";
    "super + k" = "gitkraken";
    "super + q" = "wmctrl -c :ACTIVE:";
    "super + shift + b" = "$BROWSER --incognito";
    "super + shift + g" = "google-chrome-stable --incognito";
    "super + w" = "$TERMINAL -e ranger";
    "super + z" = "autorandr -c -f";
  };

}


