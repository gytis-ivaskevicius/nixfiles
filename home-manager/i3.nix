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

  #programs.autorandr = {
  #  enable = true;
  #  profiles = {
  #    home = {
  #      fingerprint = {
  #        DP-2 = "00ffffffffffff0004726107ffffffffff1d0104b55927783bee01af4f41ac260f5054210800010101010101010101010101010101014c9a00a0f0402e60302035007a843100001a000000ff002341534d685451455663615464000000fd000190f6f663010a202020202020000000fc0058333820500a20202020202020023b020320f12309070183010000654b04000101e305c000e2006ae6060501605a2831dd00a0f0404260302035007a843100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006670137903000f000aa4140e0e07012045000002010d31fb6a4f1b74ac61e20e01455403013c933d0104ff0e9f002f801f003f065d0002000400a4810104ff0e9f002f801f003f067100020004001b060104ff0e9f002f801f003f064d000200040000000000000000000000000000000000000000000000000000000000002d90";
  #      };
  #      config.DP-2 = {
  #        enable = true;
  #        position = "0x0";
  #        primary = true;
  #        rate = "144.00";
  #        mode = "3840x1600";
  #      };
  #    };
  #  };
  #};


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
