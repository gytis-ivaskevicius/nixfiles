{ config, lib, pkgs, ... }:

{
  imports = [
    ../xorg.nix
  ];

  environment.etc = {
    "i3/autotiling.sh".source = ./autotiling.sh;
  };

  services.xserver.windowManager.i3 = {
    enable = true;
    configFile = ./i3config;
    extraPackages = [ pkgs.i3lock ];
    extraSessionCommands = "systemd --user restart autostart.target";
    package = lib.mkDefault pkgs.i3-gaps;
  };

  environment.systemPackages = with pkgs; [
    wmctrl
    xdotool
  ];

# TODO: Does not work well 20.09, needs to be fixed at some point
# To make sure all local SSH sessions are closed after a laptop lid is shut.
#powerManagement.powerDownCommands = ''
  #{pkgs.procps}/bin/pgrep ssh | IFS= read -r pid; do
  # "$(readlink "/proc/$pid/exe")" = "${pkgs.openssh}/bin/ssh" ] && kill "$pid"
  #one
  #'';

}
