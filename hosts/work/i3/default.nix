{ config, lib, pkgs, ... }:

{
  environment.etc = {
    "i3/autotiling.sh".source = ./autotiling.sh;
  };
  xdg.mime.enable = true;

  services.xserver = {

    enable = true;
    layout = "us";
    xkbOptions = "terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win";
    libinput = {
      enable = true;

      # Left + right click emulates middle button.
      touchpad.middleEmulation = true;
      #naturalScrolling = true;
    };

    # Make auto-repeat on key hold work faster.
    displayManager.xserverArgs = [
      "-ardelay 300"
      "-arinterval 20"
    ];

    displayManager.lightdm = {
      enable = true;
      greeters.enso.enable = lib.mkDefault true;
      greeters.enso.theme.name = lib.mkDefault "Numix";
      greeters.enso.theme.package = lib.mkDefault pkgs.numix-gtk-theme;

      #background
      #greeters.enso.blur
      #greeters.enso.brightness
      #greeters.enso.cursorTheme.name
      #greeters.enso.cursorTheme.package
      #greeters.enso.extraConfig
      #greeters.enso.iconTheme.name
      #greeters.enso.iconTheme.package
    };

    windowManager.i3 = {
      enable = true;
      configFile = ./i3config;
      extraPackages = [ pkgs.i3lock ];
      extraSessionCommands = "systemd --user restart autostart.target";
      package = lib.mkDefault pkgs.i3-gaps;
    };
  };

  environment.systemPackages = with pkgs; [
    wmctrl
    xclip
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
