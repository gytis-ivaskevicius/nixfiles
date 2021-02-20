{ config, pkgs, lib, ... }:

{
  imports = [
    ./cachix.nix
    ./clean-home.nix
    ./runtimes.nix
    ./nix-compose.nix
  ];
}
