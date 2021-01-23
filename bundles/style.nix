{ config, pkgs, lib, ... }:
let
  settings = ''
    [Settings]
    gtk-application-prefer-dark-theme=true
    gtk-button-images=0
    gtk-cursor-theme-name=breeze_cursors
    gtk-fallback-icon-theme=ePapirus
    gtk-icon-theme-name=ePapirus
    gtk-menu-images=0
    gtk-primary-button-warps-slider=0
    gtk-theme-name=Numix
    gtk-toolbar-style=GTK_TOOLBAR_ICONS
  '';
in
{

# environment.systemPackages = with pkgs; [
#   numix-gtk-theme
#   papirus-icon-theme
# ];

# environment.etc = {
#   "xdg/gtk-3.0/settings.ini".text = settings;
# };

# fonts = {
#   enableFontDir = true;
#   fonts = with pkgs; [
#     dejavu_fonts
#     ubuntu_font_family
#     source-code-pro
#     noto-fonts
#     noto-fonts-extra
#     noto-fonts-cjk
#     twitter-color-emoji
#     fira-code
#     fira-code-symbols
#     nerdfonts
#   ];

#   fontconfig.enable = true;
#   fontconfig.defaultFonts = {
#     monospace = lib.mkDefault [ "RobotoMono Nerd Font" "DejaVu Sans Mono" ];
#     sansSerif = lib.mkDefault [ "Roboto" "DejaVu Sans" ];
#     serif = lib.mkDefault [ "Roboto" "DejaVu Serif" ];
#     emoji = lib.mkDefault [ "Twitter Color Emoji" ];
#   };
# };

}
