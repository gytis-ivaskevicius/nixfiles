{ lib
, self
, inputs
, utils
, system
, pkgs
, nixosModules
, ...
}:
let
  inherit (builtins) attrValues removeAttrs readDir;
  inherit (lib) filterAttrs hasSuffix mapAttrs' nameValuePair removeSuffix;
  inherit (utils) recImport overlay;

  mapFilterAttrs = seive: f: attrs: filterAttrs seive (mapAttrs' f attrs);

  config = hostName:
    lib.nixosSystem {
      inherit system;


      modules =
        let
          global = {
            networking.hostName = hostName;
            nixpkgs = { pkgs = pkgs; };
            nix.nixPath = let path = toString ../.; in
              [
                "nixpkgs=${inputs.master}"
                "nixos=${inputs.nixos}"
                "nixos-config=${path}/hosts/GytisOS.nix"
              ];

            nix.package = pkgs.nixUnstable;
            nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';

            nix.registry = {
              nixos.flake = inputs.nixos;
              nixflk.flake = self;
              nixpkgs.flake = inputs.master;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          };

        in
        [
          (import "${toString ./.}/${hostName}.nix")
          global
        ] ++ nixosModules;

      extraArgs = {
        inherit system inputs;
      };
    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts
