{ lib, pkgs, config, options, ... }:

with lib;
with pkgs;
let
in
{
  imports = [ ./common.nix ./dunst.nix ];

  home.packages = with pkgs; [
    arandr
    autorandr
    pavucontrol
  ];

  home.sessionVariables = {
    MOZ_X11_EGL = "1";
  };

  xsession.enable = true;
  xsession.initExtra = "unset __NIXOS_SET_ENVIRONMENT_DONE";
  xsession.windowManager.i3 = (import ./i3-sway.nix { inherit lib pkgs config; wm = "i3"; });

  programs.autorandr = {
    enable = true;
    profiles = {
      home = {
        fingerprint = {
          DP-2 = "00ffffffffffff00410c64c15f0200001f1b0104a54627783b2815ae4f44a826125054bfef00d1c0b30095008180814081c001010101023a801871382d40582c4500ba892100001e2a4480a07038274030203500ba892100001a000000fd00304c555512010a202020202020000000fc0050484c203332384538510a2020011402031ef14b901f051404130312021101230907078301000065030c0010008c0ad08a20e02d10103e9600ba8921000018011d007251d01e206e285500ba892100001e8c0ad08a20e02d10103e9600ba89210000188c0ad090204031200c405500ba8921000018000000000000000000000000000000000000000000000000001d";
          HDMI-1 = "00ffffffffffff0005e36024070300000a1a010380351e782aa265a655559f280d5054bfef00d1c0b30095008180814081c001010101023a801871382d40582c4500132b2100001e000000fd00324c1e5311000a202020202020000000fc00323436300a2020202020202020000000ff004430344733424130303037373501f502031ef14b0514101f04130312021101230907018301000065030c0010008c0ad08a20e02d10103e9600132b21000018011d007251d01e206e285500132b2100001e8c0ad08a20e02d10103e9600132b210000188c0ad090204031200c405500132b2100001800000000000000000000000000000000000000000000000000b7";
        };
        config = {
          DP-1.enable = false;
          DP-3.enable = false;
          DVI-D-1.enable = false;

          HDMI-1 = {
            enable = true;
            position = "0x0";
            rate = "60.00";
            mode = "1920x1080";
          };
          DP-2 = {
            enable = true;
            position = "1920x0";
            primary = true;
            rate = "60.00";
            mode = "1920x1080";
          };
        };
      };
    };
  };


  services.flameshot.enable = true;
  services.polybar.enable = true;
  services.polybar.script = "polybar &";
  services.polybar.package = pkgs.g-polybar;


  services.random-background = {
    enable = true;
    interval = "1h";
    imageDirectory = "${./wallpapers}";
  };

  systemd.user.services.polkit-gnome = {
    Unit = {
      Description = "PolicyKit Authentication Agent";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };


  services.picom = {
    enable = true;
    backend = "glx";
    shadow = true;
    vSync = true;
    blur = true;
    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
      "class_g = '.ulauncher-wrapped'"
      "class_g = 'Conky'"
      "class_g = 'Peek'"
      "class_g = 'Ulauncher'"
      "class_g = 'gromit-mpx'"
      "class_g = 'i3-frame'"
      "name = 'Polybar tray window'"
      "name = 'polybar-blur-noshadow'"
      "name = 'polybar-noblur-noshadow'"
    ];
  };
}
