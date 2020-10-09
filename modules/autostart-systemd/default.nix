{ config, pkgs, lib, ... }:

let execWithEnv = pkgs.writeScriptBin "execWithEnv"
''#!${pkgs.stdenv.shell}

  unset __NIXOS_SET_ENVIRONMENT_DONE
  source /etc/profile
  exec "$@"'';
in {

  # Disables start limit burst which causes issues in case of rapid logout/login with units autostart
  systemd.user.extraConfig = ''
    DefaultStartLimitBurst=0
  '';

  systemd.user.targets.autostart = {
    description = "Target to bind applications that should be started after VM";
  };

  environment.systemPackages = [ execWithEnv ];

}
