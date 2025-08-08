{ pkgs, lib, ... }:

{

  services.upower.enable = true;

  programs.sway = {
    enable = true;
    extraPackages = [ ];
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  environment.variables = {
    SUDO_ASKPASS="${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    SSH_ASKPASS="${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

}
