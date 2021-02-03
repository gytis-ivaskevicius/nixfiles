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
  pkgImport = nixpkgs: overlays: import nixpkgs {
    inherit system overlays;
      config = {
        #replaceStdenv = { pkgs }: ((import nixpkgs { inherit system; config.allowUnfree = true;}).pkgs.gcc10Stdenv);
        #replaceStdenv = { pkgs }: pkgs.gcc10Stdenv;
        replaceStdenv = { pkgs }: pkgs.clangStdenv;
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

                nix.nixPath =
                  let path = toString ./.; in
                  (lib.mapAttrsToList (name: _v: "${name}=${inputs.${name}}") inputs) ++ [ "repl=${path}/repl.nix" ];

                nix.registry =
                  (lib.mapAttrs'
                    (name: _v: lib.nameValuePair name ({ flake = inputs.${name}; }))
                    inputs) // { ${hostName}.flake = self; };

                nix.package = pkgs.nixUnstable;
                nix.extraOptions = ''
                  experimental-features = nix-command flakes
                '';

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
