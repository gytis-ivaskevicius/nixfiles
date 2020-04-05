{ config, pkgs, lib, ... }:
{
  systemd.user.targets."applications" = {
    description = "Core DE applications startup target";
  };
}
