
{ config, pkgs, ... }:

{

  environment.variables = {
    BROWSER = "brave";
    TERMINAL = "alacritty";
  };

  environment.systemPackages = with pkgs; [
    arandr
    brave
    cinnamon.nemo
    discord
    firefox
    g-alacritty
    gnome3.eog
    pavucontrol
    vlc
  ];

}

