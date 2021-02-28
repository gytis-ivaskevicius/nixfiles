{ lib
, self
, inputs
, system
, pkgs
, nixosModules
}:
with lib;
with builtins;
let
  genAttrs' = values: f: listToAttrs (map f values);
in
{
  patchChannel = channel: patches:
    if patches == [ ] then channel else
    (import channel { inherit system; }).pkgs.applyPatches {
      name = "nixpkgs-patched-${channel.shortRev}";
      src = channel;
      patches = patches;
    };

  pkgImport = pkgs: overlays: import pkgs {
    inherit system overlays;
    config = {
      allowBroken = true;
      allowUnfree = true;
      oraclejdk.accept_license = true;
      permittedInsecurePackages = [
        "openssl-1.0.2u"
      ];
    };
  };


  buildNixosConfigurations = paths:
    genAttrs' paths (path:
      let
        hostName = removeSuffix ".host.nix" (baseNameOf path);
      in
      {
        name = hostName;
        value = nixosSystem {
          inherit system;

          modules =
            let
              global = {
                networking.hostName = hostName;
                nixpkgs = { inherit pkgs; config = pkgs.config; };

                nix.nixPath =
                  (mapAttrsToList (name: _: "${name}=${inputs.${name}}") inputs)
                  ++ [ "repl=${toString ./.}/repl.nix" ];

                nix.registry =
                  (mapAttrs' (name: _v: nameValuePair name { flake = inputs.${name}; }) inputs)
                  // { ${hostName}.flake = self; };

                nix.package = pkgs.nixUnstable;
                nix.extraOptions = ''
                  experimental-features = nix-command flakes
                '';

                system.configurationRevision = mkIf (self ? rev) self.rev;
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
