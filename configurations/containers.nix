{ pkgs, lib, ... }:

{

  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    enableOnBoot = false;
    liveRestore = false;
  };


  nix-compose.test-stack2.compose = {
    version = "3";

    services.nginx = {
      image = "nginx";
      ports = [ "8081:80" ];
    };

    services.nginx2 = {
      image = "nginx";
      ports = [ "8082:80" ];
    };

    services.nginx3 = {
      image = "nginx";
      ports = [ "8083:80" ];
    };

    volumes = {
      gytistest = { };
    };

  };
}
