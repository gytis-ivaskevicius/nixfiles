{ config, lib, pkgs, ... }:

{
  imports = [ ./nixos-upgrade.nix ];
  systemd.services.nixos-upgrade = {
    description = "Custom NixOS Upgrade";
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;
    serviceConfig.Type = "oneshot";
    environment = config.nix.envVars //
      { inherit (config.environment.sessionVariables) NIX_PATH;
        HOME = "/root";
      } // config.networking.proxy.envVars ;

    path = [ pkgs.coreutils pkgs.gnutar pkgs.xz.bin pkgs.gzip pkgs.gitMinimal config.nix.package.out ];
    script = let
        nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
      in
        ''
        ${nixos-rebuild} boot --upgrade --no-build-output
        '';
    startAt = "12:00";
  };
}
