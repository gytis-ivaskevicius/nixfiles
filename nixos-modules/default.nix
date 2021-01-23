{ config, pkgs, lib, ... }:

{
  imports = [
    ./ui.nix
    ./runtimes.nix
  ];
}
