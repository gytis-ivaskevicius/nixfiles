{ lib, pkgs, config, options, ... }:

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

  colorScheme = colorSchemeDark;
  font = "Roboto";


  bgColor = colorScheme.primary.normal.background;
  fgColor = colorScheme.primary.bright.foreground;
  acColor = colorScheme.normal.red;
  acColor2 = colorScheme.normal.yellow;

  monospaced = text: ''<span font_family="RobotoMono">'' + text + "</span>";
in
{
  imports = [ ./git.nix ./common.nix ./dunst.nix ];

  home.packages = with pkgs; [
    wl-clipboard
    wlr-randr
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    XKB_DEFAULT_OPTIONS = "terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win";
    SDL_VIDEODRIVER = "wayland";

    # needs qt5.qtwayland in systemPackages
    QT_QPA_PLATFORM="wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION="1";

    # Fix for some Java AWT applications (e.g. Android Studio),
    # use this if they aren't displayed properly:
    _JAVA_AWT_WM_NONREPARENTING=1;

    # gtk applications on wayland
    # export GDK_BACKEND=wayland
  };

  wayland.windowManager.sway = {

    extraSessionCommands = ''
      unset __NIXOS_SET_ENVIRONMENT_DONE
    '';

    extraConfig = ''

      input "type:keyboard" {
          xkb_layout us,de
          xkb_options terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win
      }

      #output HDMI-A-1 {
      #  mode 1920x1080@74.973Hz
      #  pos 0 0
      #  scale 0.75
      #  scale_filter nearest
      #  adaptive_sync on
      #}

      #output HDMI-A-1 disable

      output DP-2 {
        mode 3840x1600@143.998001Hz
        #pos 2560 0
      }

      input * {
          repeat_delay 250
          repeat_rate 35
      }
      exec wl-paste -t text --watch ${pkgs.clipman} store
    '';


    enable = true;
    config = {
      #input = {
      #"*" = {
      #"repeat_delay" = "230";
      #"repeat_rate" = "23";
      #};
      #};
      modifier = "Mod4";
      floating.modifier = "Mod4";
      floating.border = 0;
      window.border = 0;
      focus.forceWrapping = false;
      focus.followMouse = false;
      fonts = { names = [ "RobotoMono" ]; size = 9.0; };
      terminal = "${pkgs.alacritty}/bin/alacritty}";
      startup = [
        #{ command = "waybar"; always = true; notification = false; }
      ];

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
      };

      #    bars = mkForce [ ];
      bars = [{
        "command" = "${waybar}/bin/waybar";
      }];
      keybindings = mkOptionDefault (import ./keybindings.nix { inherit pkgs; });
    };
  };


  programs.waybar =
    let
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
        clock.format = "{:%Y-%m-%d %H:%M}";
        "tray" = { spacing = 8; };
        "cpu" = { format = "cpu {usage}"; };
        "memory" = { format = "mem {}"; };
        "temperature" = {
          hwmon-path = "/sys/class/hwmon/hwmon1/temp2_input";
          format = "tmp {temperatureC}C";
        };
        "pulseaudio" = {
          format = "vol {volume} {format_source}";
          format-bluetooth = "volb {volume} {format_source}";
          format-bluetooth-muted = "volb {format_source}";
          format-muted = "vol {format_source}";
          format-source = "mic {volume}";
          format-source-muted = "mic";
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

  xdg.configFile."xdg-desktop-portal-wlr/config".text = ''
    [screencast]
    output_name=
    max_fps=30
    chooser_cmd=${pkgs.slurp}/bin/slurp -f %o -or
    chooser_type=simple
  '';

}
