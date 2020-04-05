{ config, pkgs, ... }:

{
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = [
      # fonts for gnome
      pkgs.dejavu_fonts pkgs.cantarell_fonts
    ];
  };
}
