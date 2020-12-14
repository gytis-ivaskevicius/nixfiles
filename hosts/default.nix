{ lib
, pkgset
, self
, system
, ...
}:

let
  inherit (builtins) attrValues removeAttrs readDir;
  inherit (pkgset) os-pkgs unstable-pkgs custom-pkgs inputs unstable-overrides;
  inherit (lib) filterAttrs hasSuffix mapAttrs' nameValuePair removeSuffix;

  mapFilterAttrs = seive: f: attrs: filterAttrs seive (mapAttrs' f attrs);

  recImport = { dir, _import ? base: import "${dir}/${base}.nix" }:
    mapFilterAttrs
      (_: v: v != null)
      (n: v:
        if n != "default.nix" && hasSuffix ".nix" n && v == "regular"
        then
          let name = removeSuffix ".nix" n; in nameValuePair (name) (_import name)

        else
          nameValuePair ("") (null))
      (readDir dir);

  config = hostName:
    lib.nixosSystem {
      inherit system;

      modules =
        let
          global = {
            networking.hostName = hostName;
            nix.nixPath = let path = toString ../.; in
              [
                "nixpkgs=${inputs.master}"
                "nixos=${inputs.nixos}"
                "nixos-config=${path}/configuration.nix"
                "nixpkgs-overlays=${path}/overlays"
              ];

            nixpkgs = { pkgs = os-pkgs; };

            nix.registry = {
              nixos.flake = inputs.nixos;
              nixflk.flake = self;
              nixpkgs.flake = inputs.master;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          };

          overrides.nixpkgs.overlays = [
            custom-pkgs
            (final: prev: { unstable = unstable-pkgs; })
          ];

        in [
          inputs.home.nixosModules.home-manager
          (import ../nix-options)
          (import "${toString ./.}/${hostName}.nix")
          global
          overrides
        ];

      extraArgs = {
        inherit system;
      };
    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts
