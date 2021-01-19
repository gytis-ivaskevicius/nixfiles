{ pkgs, alacritty }:
let
  wrapped = pkgs.writeShellScriptBin "alacritty" "${alacritty}/bin/alacritty --config-file ${./alacritty.yml} $@";
in
pkgs.symlinkJoin {
  name = "alacritty";
  paths = [
    wrapped
    alacritty
  ];
}
