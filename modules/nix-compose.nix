{ config, pkgs, lib, ... }:

with lib;
with pkgs;
with builtins;
let
  cfg = config.nix-compose;

  getImageName = image: if isDerivation image then "${image.imageName}:${image.imageTag}" else image;
  volumesPath = "/nix/compose";

  mkContainer = composeName: compose:
    let
      imageDeriviations = mapAttrsFlatten
        (_: it: it.image)
        (filterAttrs (_: it: isDerivation it.image) compose.services);

      buildVolumePath = volumeName: volumesPath + "/" + composeName + "/" + volumeName;

      resolveVolumes = volumes: map
        (volume@{ volumeName ? null, source ? null, target }:
          if isStorePath source then {
            target = toString target;
            source = toString source;
            type = "bind";
            read_only = true;
          }
          else if volumeName != null then {
            target = toString target;
            source = buildVolumePath volumeName;
            type = "bind";
          } else volume)
        volumes;

      resolveService = service: service // {
        image = getImageName service.image;
        volumes = if service ? volumes then resolveVolumes service.volumes else [ ];
      };

      parsedServices = mapAttrs (_: service: resolveService service) compose.services;
      volumes = flatten (mapAttrsFlatten (_: service: if service ? volumes then service.volumes else [ ]) compose.services);

      nixVolumes = filter (it: it ? volumeName) volumes;
      pathsToCreate = map (it: buildVolumePath it.volumeName) nixVolumes;

      docker-compose = writeText composeName
        (toJSON (compose // { services = parsedServices; }));
    in
    {
      enable = true;
      preStart = ''
        ${concatStringsSep "\n" (map (it: "${podman}/bin/podman load -i ${it}") imageDeriviations)}
        mkdir -p ${concatStringsSep " " pathsToCreate}

      '';
      path = [ zfs podman shadow ];
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

    nix-compose.definitions = mkOption {
      default = { };
      type = with types; attrsOf (submodule composeOpts);
      description = '' '';
    };

  };

  config = {
    systemd.services = mapAttrs (name: value: mkContainer name value.compose) config.nix-compose.definitions;
  };

}
