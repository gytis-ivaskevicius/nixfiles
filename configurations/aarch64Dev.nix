{ pkgs, lib, ... }:

{

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = with pkgs; [
    tio
  ];

  nix = {
    binaryCaches = [ "https://arm.cachix.org/" ];
    binaryCachePublicKeys = [ "arm.cachix.org-1:5BZ2kjoL1q6nWhlnrbAl+G7ThY7+HaBRD9PZzqZkbnM=" ];
  };

}
