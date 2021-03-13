{
  # pass an instance of self
  self
, inputs
, utils
, system ? "x86_64-linux"

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
  maybeImport = obj:
    if (builtins.typeOf obj == "path") || (builtins.typeOf obj == "string") then
      import obj
    else
      obj;

  otherArguments = builtins.removeAttrs args [
    "self"
    "inputs"
    "utils"
    "system"
    "nixosProfiles"
    "pkgs"
    "pkgsConfig"
    "sharedModules"
    "sharedOverlays"
    "extraArgs"
  ];

in
otherArguments //
{

  pkgs = builtins.mapAttrs
    (name: value: import value.input {
      inherit system;
      overlays = sharedOverlays;
      config = pkgsConfig // (if (value ? config) then value.config else { });
    })
    pkgs;

  nixosConfigurations = builtins.mapAttrs
    (name: value:
      let
        #nixpkgs = import pkgs.nixpkgs.input { inherit system; };
        nixpkgs = if (value ? nixpkgs) then value.nixpkgs else self.pkgs.nixpkgs;

      in
      inputs.nixpkgs.lib.nixosSystem
        (
          with nixpkgs.lib;
          {
            inherit system;
            modules = [
              {
                networking.hostName = mkDefault name;
                nixpkgs = { pkgs = nixpkgs; config = nixpkgs.config; };
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




