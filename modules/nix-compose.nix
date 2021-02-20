{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.nix-compose;

  mkContainer = name: compose: with pkgs; with builtins; {
    enable = true;
    serviceConfig.ExecStart = "${docker-compose}/bin/docker-compose -f ${writeText name (toJSON compose)} up";
    wantedBy = [ "multi-user.target" ];
  };

  composeOpts = { name, config, ... }: {
    options = {
      enable = mkEnableOption "Is configuration supposed to be enabled?" // { default = true; };

      compose = mkOption {
        type = types.attrs;
        default = { };
        example = {
          version = "3";

          services.nginx = {
            image = "nginx";
            ports = [ "8080:80" ];
          };
        };
      };

    };
  };
in
{

  options = {

    nix-compose = mkOption {
      default = { };
      type = with types; attrsOf (submodule composeOpts);
      description = '' '';
    };

  };

  config = {
    systemd.services = mapAttrs (name: value: mkContainer name value.compose) config.nix-compose;
  };

}
