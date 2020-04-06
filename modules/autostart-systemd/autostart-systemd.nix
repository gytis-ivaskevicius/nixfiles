{ config, pkgs, lib, ... }:
{
  systemd.user.targets.autostart = {
    description = "Target to bind applications that should be started after VM";
  };



}
