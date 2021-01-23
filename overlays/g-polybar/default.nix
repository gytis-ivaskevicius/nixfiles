{ pkgs, polybarFull }:
let
  wrapped = pkgs.writeShellScriptBin "polybar" "${polybarFull}/bin/polybar -c ${./polybar.conf} main $@";
in
pkgs.symlinkJoin {
  name = "polybar";
  paths = [
    wrapped
    polybarFull
  ];
}
