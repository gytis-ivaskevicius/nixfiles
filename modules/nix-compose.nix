{ config, pkgs, lib, ... }:

with lib;
with pkgs;
with builtins;
let
  cfg = config.nix-compose;

  getImageName = service: if isDerivation service.image then "${service.image.imageName}:${service.image.imageTag}" else service.image;

  mkContainer = name: compose:
    let
      imageDeriviations = mapAttrsFlatten
        (_: it: it.image)
        (filterAttrs (_: it: isDerivation it.image) compose.services);
      services = mapAttrs (_: service: service // { image = getImageName service; }) compose.services;

      docker-compose = writeText name
        (toJSON (compose // { inherit services; }));
    in
    {
      enable = true;
      preStart = concatStringsSep "\n" (map (it: "${podman}/bin/podman load -i ${it}") imageDeriviations);
      path = [ podman shadow ];
      serviceConfig = {
        ExecStart = "${podman-compose}/bin/podman-compose --transform_policy=identity -f ${docker-compose} up";
        ExecStopPost = "${podman-compose}/bin/podman-compose -f ${docker-compose} down";
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };

  composeOpts = { name, config, ... }: {
    options = {
      enable = mkEnableOption "Is configuration supposed to be enabled?" // { default = true; };

      compose = mkOption {
        type = types.attrs;
        default = { };
        example = {
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
