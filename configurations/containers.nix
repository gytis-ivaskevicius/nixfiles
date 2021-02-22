{ pkgs, lib, ... }:

{

  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    enableOnBoot = false;
    liveRestore = false;
  };


  nix-compose.test-stack2.compose = {

    services.hello.image = pkgs.dockerTools.buildImage {
      name = "hello-docker";
      config = {
        Cmd = [ "${pkgs.hello}/bin/hello" ];
      };
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
      test = { };
    };

  };

}
