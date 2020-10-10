{ config, pkgs, ... }:

let
  wrapped_lf = pkgs.writeScriptBin "lf" ''
    #!/usr/bin/env bash
    export FIFO_UEBERZUG="/tmp/lf-ueberzug-''${PPID}"

    function cleanup {
      rm "$FIFO_UEBERZUG" 2>/dev/null
      pkill -P $$
    }

    mkfifo "$FIFO_UEBERZUG"
    trap cleanup EXIT
    tail --follow "$FIFO_UEBERZUG" | ueberzug layer --silent --parser bash &

    ${pkgs.lf}/bin/lf $@
  '';
in {

  environment.systemPackages = with pkgs; [
    atool
    bat
    bc
    ffmpegthumbnailer
    imagemagick
    pistol
    poppler
    ueberzug
    wrapped_lf
    zip
#     pkgs.epub-thumbnailer
  ];

  environment.etc = {
    "lf/lfrc".source = ./lfrc;
    "lf/previewer.sh".source = ./previewer.sh;
    "lf/image.sh".source = ./image.sh;
  };

  environment.shellInit = builtins.readFile ./shellInit.sh;
}
