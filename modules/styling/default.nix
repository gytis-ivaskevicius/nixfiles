{ config, pkgs, lib, ... }:
{

  environment.systemPackages = with pkgs; [
    numix-gtk-theme
    papirus-icon-theme
    qt5.qtbase
  ];

  environment.etc = {
    "xdg/gtk-3.0/settings.ini".source = ./settings.ini;
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      dejavu_fonts
      ubuntu_font_family
      source-code-pro
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk
      twitter-color-emoji
      fira-code
      fira-code-symbols
      nerdfonts
    ];

    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      monospace = ["RobotoMono Nerd Font" "DejaVu Sans Mono" ];
      sansSerif = [ "Roboto" "DejaVu Sans" ];
      serif = [ "Roboto" "DejaVu Serif" ];
      emoji = [ "Twitter Color Emoji" ];
    };
  };

  console.packages = with pkgs; [ terminus_font ];
  console.font = "ter-v12n";

}
