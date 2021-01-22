{ ... }:

{
  imports = [
    ./hosts/GytisOS.nix
    ./nix-options
  ];

  nixpkgs.overlays = [ (import ./pkgs) ];
}
