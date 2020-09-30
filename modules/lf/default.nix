{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    atool
    lf
    unstable.pistol
    zip
  ];

  environment.etc = {
    "lf/lfrc".source = ./lfrc;
  };

  environment.shellInit = builtins.readFile ./shellInit.sh;
}
