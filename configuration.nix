{ ... }:

{
  imports = [
    ./hosts/GytisOS.nix
    ./nix-options
  ];

  nixpkgs.overlays = [ (import ./pkgs) ];
   system.stateVersion = "20.09";
}

