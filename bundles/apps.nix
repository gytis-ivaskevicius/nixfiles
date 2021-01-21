{ config, pkgs, ... }:

{

  environment.variables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    MOZ_X11_EGL = "1";
  };

  environment.systemPackages = with pkgs; [
    arandr
    autorandr
    brave
    cinnamon.nemo
    discord
    firefox-beta-bin
    g-alacritty
    gnome3.eog
    pavucontrol
    vlc
  ];

}
