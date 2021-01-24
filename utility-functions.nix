{ lib
, self
, inputs
, system
, pkgs
, nixosModules
}:
let
  inherit (lib) removeSuffix;
  inherit (builtins) listToAttrs;
  genAttrs' = values: f: listToAttrs (map f values);

in
{
  pkgImport = pkgs: overlays: import pkgs {
    inherit system overlays;
    config = {
      allowUnfree = true;
      oraclejdk.accept_license = true;
    };
  };


  buildNixosConfigurations = paths:
    genAttrs' paths (path:
      let
        hostName = removeSuffix ".host.nix" (baseNameOf path);
      in
      {
        name = hostName;
        value = lib.nixosSystem {
          inherit system;

          modules =
            let
              global = {
                networking.hostName = hostName;
                nixpkgs = { inherit pkgs; config = pkgs.config; };
                nix.nixPath = let path = toString ./.; in
                  [
                    "master=${inputs.master}"
                    "nixpkgs=${inputs.nixpkgs}"
                    "nixos-config=${path}/configuration.nix"
                  ];

                nix.package = pkgs.nixUnstable;
                nix.extraOptions = ''
                  experimental-features = nix-command flakes
                '';

                nix.registry = {
                  nixpkgs.flake = inputs.nixpkgs;
                  nixflk.flake = self;
                  master.flake = inputs.master;
                };

                system.configurationRevision = lib.mkIf (self ? rev) self.rev;
              };

            in
            [
              (import path)
              global
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
              }
            ] ++ nixosModules;

          extraArgs = {
            inherit system inputs;
          };
        };
      });
}
