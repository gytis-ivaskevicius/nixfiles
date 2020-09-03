{ config, pkgs, lib, ... }:
{
  environment.systemPackages = [ pkgs.dunst ];

  environment.etc = {
    "xdg/dunst/dunstrc".source = ./dunst.conf;
  };
}
