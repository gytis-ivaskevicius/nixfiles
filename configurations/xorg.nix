{ config, lib, pkgs, ... }:

{
  xdg.mime.enable = true;
  environment.systemPackages = with pkgs; [ xclip ];

  gytix.ui.polkit-ui.enable = true;

  services.dbus.packages = with pkgs; [ gnome3.dconf ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = lib.mkDefault "terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win";
    libinput = {
      enable = lib.mkDefault true;
      # Left + right click emulates middle button.
      middleEmulation = lib.mkDefault true;
      #naturalScrolling = true;
      tapping = lib.mkDefault false;
      tappingDragLock = lib.mkDefault false;
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
  };

  # TODO: Does not work well 20.09, needs to be fixed at some point
  # To make sure all local SSH sessions are closed after a laptop lid is shut.
  #powerManagement.powerDownCommands = ''
  #{pkgs.procps}/bin/pgrep ssh | IFS= read -r pid; do
  # "$(readlink "/proc/$pid/exe")" = "${pkgs.openssh}/bin/ssh" ] && kill "$pid"
  #one
  #'';

}
