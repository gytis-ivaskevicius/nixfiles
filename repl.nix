let
  flake = builtins.getFlake (toString ./.);
  nixpkgs = import <nixpkgs> { };
in
{ inherit flake; }
// flake
// nixpkgs
// nixpkgs.lib
// flake.nixosConfigurations
