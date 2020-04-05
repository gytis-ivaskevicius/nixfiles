{ config, pkgs, lib, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

}
