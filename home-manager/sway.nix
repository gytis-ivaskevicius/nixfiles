{ lib, pkgs, config, options, ... }:

with lib;
with pkgs;
let
    colorSchemeDark = rec {
    primary = {
      normal = {
        background = "181818";
        foreground = "b9b9b9";
      };
      bright = {
        background = bright.black;
        foreground = bright.white;
      };
    };
    normal = {
      black = "252525";
      gray = "5b5b5b";
      red = "ed4a46";
      green = "70b433";
      yellow = "dbb32d";
      blue = "368aeb";
      magenta = "eb6eb7";
      cyan = "3fc5b7";
      white = "777777";
    };
    bright = {
      black = "3b3b3b";
      gray = "7b7b7b";
      red = "ff5e56";
      green = "83c746";
      yellow = "efc541";
      blue = "4f9cfe";
      magenta = "ff81ca";
      cyan = "56d8c9";
      white = "dedede";
    };
  };

  colorScheme =
    # if builtins.pathExists ./light then colorSchemeLight else colorSchemeDark;
    colorSchemeDark;
    font = "Roboto";


  bgColor = colorScheme.primary.normal.background;
  fgColor = colorScheme.primary.bright.foreground;
  acColor = colorScheme.normal.red;
  acColor2 = colorScheme.normal.yellow;

  monospaced = text: ''<span font_family="RobotoMono">'' + text + "</span>";
   input = {"*" = {
        "xkb_layout" = "us,ru";
        "xkb_options" = "grp:caps_toggle,grp_led:caps";
    };};
in
{
  imports = [ ./common.nix ];
#    wayland.windowManager.sway.extraSessionCommands= ''
#    export SDL_VIDEODRIVER=wayland
#    # needs qt5.qtwayland in systemPackages
#    export QT_QPA_PLATFORM=wayland
#    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
#    # Fix for some Java AWT applications (e.g. Android Studio),
#    # use this if they aren't displayed properly:
#    export _JAVA_AWT_WM_NONREPARENTING=1
#    # firefox on wayland
#    export MOZ_ENABLE_WAYLAND=1 firefox
#    # gtk applications on wayland
#    # export GDK_BACKEND=wayland
#    '';

  home.packages = with pkgs; [
  ];

  home.sessionVariables = {
    XKB_DEFAULT_OPTIONS="terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win";
  };
  xsession.initExtra = ''
    unset __NIXOS_SET_ENVIRONMENT_DONE
  '';

  wayland.windowManager.sway = (import ./i3-sway.nix { inherit lib pkgs config; wm = "sway"; });

    programs.waybar = let
          swayEnabled = config.wayland.windowManager.sway.enable;
        in
        {
          enable = config.wayland.windowManager.sway.enable || config.wayland.windowManager.hikari.enable;
          settings = [{
            layer = "top";
            position = "top";
            modules-left = if swayEnabled then [ "sway/workspaces" ] else [ ];
            modules-center = if swayEnabled then [ "sway/window" ] else [ ];
            modules-right =
              [ "pulseaudio" "cpu" "memory" "temperature" "clock" "tray" ];
            modules = {
              "tray" = { spacing = 8; };
              "cpu" = { format = "/cpu {usage}/"; };
              "memory" = { format = "/mem {}/"; };
              "temperature" = {
                hwmon-path = "/sys/class/hwmon/hwmon1/temp2_input";
                format = "/tmp {temperatureC}C/";
              };
              "pulseaudio" = {
                format = "/vol {volume}/ {format_source}";
                format-bluetooth = "/volb {volume}/ {format_source}";
                format-bluetooth-muted = "/volb/ {format_source}";
                format-muted = "/vol/ {format_source}";
                format-source = "/mic {volume}/";
                format-source-muted = "/mic/";
              };
            };
          }];
          style =
            let
              makeBorder = color: "border-bottom: 3px solid #${color};";
              makeInfo = color: ''
                color: #${color};
                ${makeBorder color}
              '';

              clockColor = colorScheme.bright.magenta;
              cpuColor = colorScheme.bright.green;
              memColor = colorScheme.bright.blue;
              pulseColor = {
                normal = colorScheme.bright.cyan;
                muted = colorScheme.bright.gray;
              };
              tmpColor = {
                normal = colorScheme.bright.yellow;
                critical = colorScheme.bright.red;
              };
            in
            ''
              * {
                  border: none;
                  border-radius: 0;
                  /* `otf-font-awesome` is required to be installed for icons */
                  font-family: ${font};
                  font-size: 13px;
                  min-height: 0;
              }
              window#waybar {
                  background-color: #${bgColor};
                  /* border-bottom: 0px solid rgba(100, 114, 125, 0.5); */
                  color: #${fgColor};
                  transition-property: background-color;
                  transition-duration: .5s;
              }
              #workspaces button {
                  padding: 0 5px;
                  background-color: transparent;
                  color: #${fgColor};
                  border-bottom: 3px solid transparent;
              }
              /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
              #workspaces button:hover {
                  background: rgba(0, 0, 0, 0.2);
                  box-shadow: inherit;
                  border-bottom: 3px solid #ffffff;
              }
              #workspaces button.focused {
                  border-bottom: 3px solid #${acColor};
              }
              #workspaces button.urgent {
                  background-color: #${acColor};
                  color: #${bgColor};
              }
              #mode {
                  background-color: #64727D;
                  border-bottom: 3px solid #ffffff;
              }
              #clock,
              #battery,
              #cpu,
              #memory,
              #temperature,
              #backlight,
              #network,
              #pulseaudio,
              #custom-media,
              #tray,
              #mode,
              #idle_inhibitor,
              #mpd {
                  padding: 0 10px;
                  margin: 0 4px;
                  background-color: transparent;
                  ${makeInfo fgColor}
              }
              label:focus {
                  color: #000000;
              }
              #clock {
                  ${makeInfo clockColor}
              }
              #cpu {
                  ${makeInfo cpuColor}
              }
              #memory {
                  ${makeInfo memColor}
              }
              #pulseaudio {
                  ${makeInfo pulseColor.normal}
              }
              #pulseaudio.muted {
                  ${makeInfo pulseColor.muted}
              }
              #temperature {
                  ${makeInfo tmpColor.normal}
              }
              #temperature.critical {
                  ${makeInfo tmpColor.critical}
              }
            '';
          };




}
