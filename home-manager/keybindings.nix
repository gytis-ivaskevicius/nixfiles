{ pkgs }:

with pkgs;
let
  modifier = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  _ = pkgs.lib.getExe;

  ocrScript = pkgs.writeShellScript "ocr.sh" ''
    ${_ pkgs.grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract} - - | ${wl-clipboard}/bin/wl-copy
    ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
  '';
in
{
  "${modifier}+p" = ''exec /bin/sh -c "cat /home/gytis/notes | ${pkgs.g-rofi}/bin/rofi -dmenu | ${pkgs.findutils}/bin/xargs ${pkgs.wtype}/bin/wtype"'';
  Print = ''exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp -d)" - | ${wl-clipboard}/bin/wl-copy -t image/png'';
  XF86AudioMute = "exec ${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
  XF86AudioPlay = "exec ${playerctl}/bin/playerctl play";
  XF86AudioPause = "exec ${playerctl}/bin/playerctl pause";
  XF86AudioNext = "exec ${playerctl}/bin/playerctl next";
  XF86AudioPrev = "exec ${playerctl}/bin/playerctl prev";
  XF86AudioRaiseVolume = "exec ${pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ +5%";
  XF86AudioLowerVolume = "exec ${pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ -5%";
  XF86MonBrightnessUp = "exec ${xorg.xbacklight} -inc 20";
  XF86MonBrightnessDown = "exec ${xorg.xbacklight} -dec 20";

  "${modifier}+o" = "exec ${ocrScript}";
  "${modifier}+b" = "exec chromium";
  "${modifier}+shift+b" = "exec chromium --incognito";
  "${modifier}+z" = "exec ${autorandr}/bin/autorandr -c -f";

  #"${modifier}+t" = ''[class="scratchterm"] scratchpad show, move position center'';
  #"${modifier}+b" = ''[class="scratchbrowser"] scratchpad show, move position center '';

  #"${modifier}+Return" = "exec ${g-alacritty}/bin/alacritty";
  "${modifier}+q" = "kill";

  "${modifier}+${left}" = "focus left; exec $movemouse";
  "${modifier}+${down}" = "focus down; exec $movemouse";
  "${modifier}+${up}" = "focus up; exec $movemouse";
  "${modifier}+${right}" = "focus right; exec $movemouse";

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

  "${modifier}+0" = "workspace number 10";
  "${modifier}+Shift+0" = "move container to workspace number 10";

  "${modifier}+Shift+r" = "restart";

}
