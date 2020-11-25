{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-unstable.url = "nixpkgs/master";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }: {

    packages."x86_64-linux" = import ./pkgs;


    nixosConfigurations.GytisOS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };

  };
}
