{ config, pkgs, lib, ... }:

let
  polybar = pkgs.polybar.override {
    i3GapsSupport = true;
    alsaSupport = true;
  };
  execWithEnv = pkgs.writeScriptBin "execWithEnv"
    ''#!${pkgs.stdenv.shell}

  unset __NIXOS_SET_ENVIRONMENT_DONE
  source /etc/profile
  exec "$@"'';

in
{

  systemd.user.targets.autostart = {
    description = "Target to bind applications that should be started after VM";
  };

  environment.systemPackages = with pkgs; [
    execWithEnv
    dunst
    autorandr
    flameshot
    polybar
    feh
    networkmanagerapplet
    #pantheon.pantheon-agent-polkit
    numix-gtk-theme
    papirus-icon-theme
    qt5.qtbase
    i3lock-fancy-rapid
    sxhkd
    g-rofi
  ];

  environment.etc = {
    "xdg/dunst/dunstrc".source = ./dunst.conf;
    "xdg/gtk-3.0/settings.ini".source = ./settings.ini;
  };

  systemd.user.services.sxhkd = {
    description = "Simple X hotkey daemon";
    wantedBy = [ "autostart.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.sxhkd}/bin/sxhkd -c ${./sxhkd.conf}";
    };
  };

  systemd.user.services.polybar = {
    description = "Polybar system status bar";
    wantedBy = [ "autostart.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${polybar}/bin/polybar -c ${./polybar.conf} main";
    };
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      #dejavu_fonts
      #ubuntu_font_family
      #source-code-pro
      noto-fonts
      #noto-fonts-extra
      #noto-fonts-cjk
      #twitter-color-emoji
      #fira-code
      #fira-code-symbols
      nerdfonts
    ];

    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      monospace = lib.mkDefault [ "RobotoMono Nerd Font" "DejaVu Sans Mono" ];
      sansSerif = lib.mkDefault [ "Roboto" "DejaVu Sans" ];
      serif = lib.mkDefault [ "Roboto" "DejaVu Serif" ];
      emoji = lib.mkDefault [ "Twitter Color Emoji" ];
    };
  };

  console.packages = with pkgs; [ terminus_font ];
  console.font = "ter-v12n";

  systemd.user.services.autorandr = {
    description = "Autorandr execution hook";
    wantedBy = [ "autostart.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.autorandr}/bin/autorandr --change";
    };
  };

  systemd.user.services.flameshot = {
    description = "Flameshot";
    wantedBy = [ "autostart.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.flameshot}/bin/flameshot";
    };
  };


  systemd.user.services.nm-applet = {
    description = "Network Manager Applet";
    wantedBy = [ "autostart.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    };
  };



  systemd.user.services.polkit-ui = {
    description = "Polkit UI popup";
    wantedBy = [ "autostart.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
    };
  };


  systemd.user.services.feh = {
    description = "Feh";
    wantedBy = [ "autostart.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.feh}/bin/feh --randomize --no-fehbg --bg-fill ${./Wallpapers}";
    };
  };


  services.compton = {
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

    settings.blur-background-exclude = [
      "!(name = 'polybar-blur-shadow' || name = 'polybar-blur-noshadow' || name = 'polybar-backdrop' || class_g = 'URxvt' || class_g = 'Rofi' || class_g = 'Dunst' || class_g = 'Atom' || class_g = 'VSCodium' || class_g = 'Termite' || class_g = 'Conky' || name = 'Polybar tray window')"
    ];

  };

}
