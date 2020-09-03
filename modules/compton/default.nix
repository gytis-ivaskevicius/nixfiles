{ config, pkgs, lib, ... }:
{
  services.compton = {
    enable=true;
    backend="glx";
    shadow=true;
    vSync=true;
    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
      "class_g = '.ulauncher-wrapped'"
      "class_g = 'Conky'"
      "class_g = 'Peek'"
      "class_g = 'Ulauncher'"
      "class_g = 'gromit-mpx'"
      "class_g = 'i3-frame'"
      "name = 'Polybar tray window'"
      "name = 'polybar-blur-noshadow'"
      "name = 'polybar-noblur-noshadow'"
    ];

    settings.blur-background-exclude = [
      "!(name = 'polybar-blur-shadow' || name = 'polybar-blur-noshadow' || name = 'polybar-backdrop' || class_g = 'URxvt' || class_g = 'Rofi' || class_g = 'Dunst' || class_g = 'Atom' || class_g = 'VSCodium' || class_g = 'Termite' || class_g = 'Conky' || name = 'Polybar tray window')"
    ];

  };

}
