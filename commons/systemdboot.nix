{ config, pkgs, ... }:

{
  boot = {
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
  };
}
