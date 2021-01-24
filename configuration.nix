{ ... }:

{
  imports = [
    ./hosts/GytisOS.nix
    ./modules
  ];

  nixpkgs.overlays = [ (import ./overlays) ];
}
