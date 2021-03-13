{
  # pass an instance of self
  self
, inputs
, defaultSystem ? "x86_64-linux"

, nixosProfiles ? { }

, pkgs ? { }

  # shared pkgs config
, pkgsConfig ? { }

  # use this to load other flakes modules to supplment nixosConfigurations
, sharedModules ? [ ]

  # use this to load other flakes overlays to supplement nixpkgs
, sharedOverlays ? [ ]

, extraArgs ? { inherit inputs; }
, ...
}@args:


let
  otherArguments = builtins.removeAttrs args [
    "defaultSystem"
    "extraArgs"
    "inputs"
    "nixosProfiles"
    "pkgs"
    "pkgsConfig"
    "self"
    "sharedModules"
    "sharedOverlays"
  ];
in
otherArguments //
{

  pkgs = builtins.mapAttrs
    (name: value: import value.input {
      system = (if (value ? system) then value.system else defaultSystem);
      overlays = sharedOverlays;
      config = pkgsConfig // (if (value ? config) then value.config else { });
    })
    pkgs;

  nixosConfigurations = builtins.mapAttrs
    (name: value:
      let
        selectedNixpkgs = if (value ? nixpkgs) then value.nixpkgs else self.pkgs.nixpkgs;
      in
      inputs.nixpkgs.lib.nixosSystem (
        with selectedNixpkgs.lib;
        {
          system = selectedNixpkgs.system;
          modules = [
            {
              networking.hostName = name;
              nixpkgs = rec { pkgs = selectedNixpkgs; config = pkgs.config; };
              system.configurationRevision = mkIf (self ? rev) self.rev;
            }
          ]
          ++ sharedModules
          ++ (optionals (value ? modules) value.modules);
          extraArgs = extraArgs // optionalAttrs (value ? extraArgs) value.extraArgs;
        }
      ))
    nixosProfiles;

}

