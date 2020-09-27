{ config, pkgs, lib, ... }:

let
  conf = pkgs.writeText "rofi.rasi" "${builtins.readFile ./rofi.rasi}";
  wrapped = pkgs.writeScriptBin "rofi" ''
    #!/bin/sh
    exec ${pkgs.rofi}/bin/rofi -theme ${conf} $@
  '';
in {

  environment.systemPackages = [
    wrapped
  ];

}

