{ config, lib, pkgs, ... }:
let
  i3config = ''
    exec --no-startup-id ${./autotiling.sh}

    set $mod Mod4

    set $left h
    set $down j
    set $up k
    set $right l

    set $ws1 "1"
    set $ws2 "2"
    set $ws3 "3"
    set $ws4 "4"
    set $ws5 "5"
    set $ws6 "6"
    set $ws7 "7"
    set $ws8 "8"
    set $ws9 "9"
    set $ws10 "10"

    smart_gaps on
    font pango:RobotoMono 9

    new_window pixel
    default_border pixel 0

    set $bg-color            #424242
    set $inactive-bg-color   #424242
    set $text-color          #4f97d7
    set $inactive-text-color #676E7D
    set $urgent-bg-color     #E53935

    #                       border              background         text                 indicator
    client.focused          $bg-color           $bg-color          $text-color          #00ff00
    client.unfocused        $inactive-bg-color  $inactive-bg-color $inactive-text-color #00ff00
    client.focused_inactive $inactive-bg-color  $inactive-bg-color $inactive-text-color #00ff00
    client.urgent           $urgent-bg-color    $urgent-bg-color   $text-color

    focus_follows_mouse no

    floating_modifier $mod

    bindsym Ctrl+Shift+l exec i3lock-pixeled

    set $movemouse "sh -c 'eval `xdotool getactivewindow getwindowgeometry --shell`; xdotool mousemove $((X+WIDTH/2)) $((Y+HEIGHT/2))'"

    bindsym $mod+$left focus left; exec $movemouse
    bindsym $mod+$down focus down; exec $movemouse
    bindsym $mod+$up focus up; exec $movemouse
    bindsym $mod+$right focus right; exec $movemouse

    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right

    bindsym $mod+c split h
    bindsym $mod+v split v

    bindsym $mod+f fullscreen toggle

    bindsym $mod+s layout stacking
    bindsym $mod+t layout tabbed
    bindsym $mod+e layout toggle split

    bindsym $mod+Shift+x floating toggle
    bindsym $mod+x focus mode_toggle
    bindsym $mod+a focus parent

    bindsym $mod+Shift+c reload
    bindsym $mod+Shift+r restart

    # exit i3 (logs you out of your X session)
    bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'Do you wish to exit i3?' -B 'Yes, exit i3' 'i3-msg exit'"
    bindsym $mod+Shift+a exec "$TERMINAL"

    bindsym $mod+1 workspace $ws1
    bindsym $mod+2 workspace $ws2
    bindsym $mod+3 workspace $ws3
    bindsym $mod+4 workspace $ws4
    bindsym $mod+5 workspace $ws5
    bindsym $mod+6 workspace $ws6
    bindsym $mod+7 workspace $ws7
    bindsym $mod+8 workspace $ws8
    bindsym $mod+9 workspace $ws9
    bindsym $mod+0 workspace $ws10

    bindsym $mod+Shift+1 move container to workspace $ws1
    bindsym $mod+Shift+2 move container to workspace $ws2
    bindsym $mod+Shift+3 move container to workspace $ws3
    bindsym $mod+Shift+4 move container to workspace $ws4
    bindsym $mod+Shift+5 move container to workspace $ws5
    bindsym $mod+Shift+6 move container to workspace $ws6
    bindsym $mod+Shift+7 move container to workspace $ws7
    bindsym $mod+Shift+8 move container to workspace $ws8
    bindsym $mod+Shift+9 move container to workspace $ws9
    bindsym $mod+Shift+0 move container to workspace $ws10

    bindsym $mod+Ctrl+h move workspace to output right
    bindsym $mod+Ctrl+j move workspace to output down
    bindsym $mod+Ctrl+k move workspace to output up
    bindsym $mod+Ctrl+l move workspace to output left

    for_window [title="win0"] floating enable


    bindsym $mod+Shift+g mode "$mode_gaps"
    set $mode_gaps Gaps: 0 | + | -
    mode "$mode_gaps" {
      bindsym plus  gaps inner current plus 5
      bindsym minus gaps inner current minus 5
      bindsym 0     gaps inner current set 0

      bindsym Return mode "$mode_gaps"
      bindsym Escape mode "default"
    }


    bindsym $mod+r mode "resize"
    mode "resize" {
      bindsym $left resize shrink width 10 px or 10 ppt
      bindsym $down resize grow height 10 px or 10 ppt
      bindsym $up resize shrink height 10 px or 10 ppt
      bindsym $right resize grow width 10 px or 10 ppt

      bindsym $left+Shift resize shrink width 3 px or 3 ppt
      bindsym $down+Shift resize grow height 3 px or 3 ppt
      bindsym $up+Shift resize shrink height 3 px or 3 ppt
      bindsym $right+Shift resize grow width 3 px or 3 ppt

      bindsym Return mode "default"
      bindsym Escape mode "default"
      bindsym $mod+r mode "default"
    }
  '';
in
{

  imports = [
    ./xorg.nix
  ];

  services.xserver.windowManager.i3 = {
    enable = true;
    configFile = pkgs.writeText "i3.conf" i3config;
    extraPackages = [ ];
    package = pkgs.i3-gaps;
  };
  environment.etc."sway/config".text = i3config;

  environment.systemPackages = with pkgs; [
    xdotool
  ];

  # TODO: Does not work well 20.09, needs to be fixed at some point
  # To make sure all local SSH sessions are closed after a laptop lid is shut.
  #powerManagement.powerDownCommands = ''
  #{pkgs.procps}/bin/pgrep ssh | IFS= read -r pid; do
  # "$(readlink "/proc/$pid/exe")" = "${pkgs.openssh}/bin/ssh" ] && kill "$pid"
  #one
  #'';

  gytix.ui.autorandr.enable = true;
  gytix.ui.feh.enable = true;
  gytix.ui.flameshot.enable = true;
  gytix.ui.nm-applet.enable = true;
  gytix.ui.polkit-ui.enable = true;
  gytix.ui.polybar.enable = true;
  gytix.ui.sxhkd.enable = true;

  gytix.ui.keybindings = {
    "Print" = "${flameshot}/bin/flameshot gui";
    "XF86AudioMute" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
    "XF86Audio{Play,Pause,Next,Prev}" = "playerctl {play,pause,next,previous}";
    "XF86Audio{RaiseVolume,LowerVolume}" = "pactl set-sink-volume @DEFAULT_SINK@ {+5%,-5%}";
    "XF86MonBrightness{Up,Down}" = "xbacklight -{inc,dec} 20";
    "alt + shift + l" = "${pkgs.i3lock-pixeled}/bin/i3lock-pixeled";
    "super + Return" = "$TERMINAL";
    "super + b" = "$BROWSER";
    "super + d" = "${pkgs.g-rofi}/bin/rofi -show drun -modi drun";
    "super + g" = "google-chrome-stable";
    "super + i" = "idea-ultimate";
    "super + q" = "${pkgs.wmctrl}/bin/wmctrl -c :ACTIVE:";
    "super + shift + b" = "$BROWSER --incognito";
    "super + shift + g" = "google-chrome-stable --incognito";
    "super + w" = "$TERMINAL -e ranger";
    "super + z" = "${pkgs.autorandr}/bin/autorandr -c -f";
  };

}
