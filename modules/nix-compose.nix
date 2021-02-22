{ config, pkgs, lib, ... }:

with lib;
with pkgs;
with builtins;
let
  cfg = config.nix-compose;

  getImageName = service: if isDerivation service.image then "${service.image.imageName}:${service.image.imageTag}" else service.image;

  mkContainer = name: compose:
    let
      servicesWithDeriviations = filterAttrs (_: it: isDerivation it.image) compose.services;
      imageDeriviations = mapAttrsFlatten (_: it: it.image) servicesWithDeriviations;
      services = mapAttrs (_: service: service // { image = getImageName service; }) compose.services;

      resultCompose = compose // { inherit services; };
    in
    {
      enable = true;
      preStart = concatStringsSep "\n" (map (it: "${docker}/bin/docker load -i ${it};") imageDeriviations);
      serviceConfig.ExecStart = "${docker-compose}/bin/docker-compose -f ${writeText name (toJSON resultCompose)} up";
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
