{
  description = "A highly structured configuration database.";

  inputs = {
    master.url = "nixpkgs/master";
    nixos.url = "nixpkgs/release-20.09";
    home.url = "github:nix-community/home-manager/release-20.09";
  };

  outputs = inputs@{ self, master, nixos, home }:
  let
    inherit (self.inputs.nixos) lib;
    inherit (builtins) listToAttrs;
    inherit (lib) removeSuffix recursiveUpdate genAttrs;

      # Generate an attribute set by mapping a function over a list of values.
      genAttrs' = values: f: listToAttrs (map f values);

      pathsToImportedAttrs = paths: genAttrs' paths (path: {
        name = removeSuffix ".nix" (baseNameOf path);
        value = import path;
      });

      pkgImport = pkgs: import pkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      system = "x86_64-linux";
      os-pkgs = pkgImport self.inputs.nixos;
      unstable-pkgs = pkgImport self.inputs.master;
      unstable-overrides = (final: prev: [
        unstable-pkgs.jdk
        #jetbrains.idea-ultimate
      ]);

      pkgset = {
        inherit os-pkgs unstable-pkgs unstable-overrides;
        inputs = self.inputs;
        custom-pkgs = import ./pkgs;
        nix-options = [
          ./nix-options/ui.nix
          ./nix-options/runtimes.nix
        ];
      };
  in
  with pkgset;
  {
    nixosConfigurations = import ./hosts (recursiveUpdate inputs {
      inherit lib pkgset system ;
    });

    overlay = pkgset.custom-pkgs;
    packages."${system}" = self.overlay;

    nixosModules = recursiveUpdate (pathsToImportedAttrs pkgset.nix-options);
  };
}
