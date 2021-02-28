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
rec {
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


  buildNixosSystem = hostName: path: nixosSystem {
    inherit system;

    modules = [
      {
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

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
      (import path)
    ] ++ nixosModules;

    extraArgs = {
      inherit system inputs;
    };
  };

  buildNixosConfigurations = paths:
    genAttrs' paths (path: rec {
      name = removeSuffix ".host.nix" (baseNameOf path);
      value = buildNixosSystem name path;
    });
}
