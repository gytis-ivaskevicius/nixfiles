{ config, pkgs, lib, ... }:
{
  services.compton = {
    enable=true;
    backend="glx";
    shadow=true;
    vSync=true;
    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
      "class_g = 'Conky'"
      "class_g = 'Peek'"
      "class_g = 'Ulauncher'"
      "class_g = 'gromit-mpx'"
      "class_g = 'i3-frame'"
      "name = 'Polybar tray window'"
      "name = 'polybar-blur-noshadow'"
      "name = 'polybar-noblur-noshadow'"
    ];

  };

}
