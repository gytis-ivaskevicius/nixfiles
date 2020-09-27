{ config, pkgs, lib, ... }:

let
  wrapped = pkgs.writeScriptBin "rofi" ''
    #!/bin/sh
    exec ${pkgs.rofi}/bin/rofi -theme ${./rofi.rasi} $@
  '';
in {

  environment.systemPackages = [
    wrapped
  ];

}

