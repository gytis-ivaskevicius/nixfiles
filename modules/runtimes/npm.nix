{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ nodejs ]; 
  programs.npm.enable = true;
}
