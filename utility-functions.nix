{ lib
, self
, inputs
, system
, pkgs
, nixosModules
}:
with lib;
with builtins;
{
  patchChannel = channel: patches:
    if patches == [ ] then channel else
    (import channel { inherit system; }).pkgs.applyPatches {
      name = "nixpkgs-patched-${channel.shortRev}";
      src = channel;
      patches = patches;
    };
}
