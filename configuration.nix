{ ... }:

{
  imports = [
    ./hosts/GytisOS.nix
    ./nixos-modules
  ];

  nixpkgs.overlays = [ (import ./overlays) ];
}
