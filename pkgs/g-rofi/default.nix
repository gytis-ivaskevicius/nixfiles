{ pkgs, rofi }:

let
  wrapped = pkgs.writeScriptBin "rofi" ''
    #!/bin/sh
    exec ${rofi}/bin/rofi -theme ${./rofi.rasi} $@
  '';
in
  pkgs.symlinkJoin {
    name = "rofi";
    paths = [
      wrapped
      rofi
    ];
  }
