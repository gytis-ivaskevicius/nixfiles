{ pkgs, lib, ... }:

{

  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    enableOnBoot = false;
    liveRestore = false;
  };

  virtualisation.podman.enable = true;
  virtualisation.containers.registries.search = [ "docker.io" ];

  nix-compose.definitions.test-stack2.compose = {

    services.hello.image = pkgs.dockerTools.buildImage {
      name = "hello-docker";
      config = {
        Cmd = [ "${pkgs.hello}/bin/hello" ];
      };
    };


    #services.nginx3 = {
    #  image = "nginx";
    #  ports = [ "8083:80" ];
    #  volumes = [
    #    (bind "/usr/share/nginx/html/index.html" (pkgs.writeText "index.html" "Man, SCREW WORLD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"))
    #    (volume "test-volume" "/my-volume")
    #    (volume "test-volume2" "/my-volume2")
    #  ];
    #};




    services.nginx3 = {
      image = "nginx";
      ports = [ "8083:80" ];
      volumes = [
        {
          source = pkgs.writeText "index.html" "Man, SCREW WORLD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
          target = "/usr/share/nginx/html/index.html";
        }
        {
          volumeName = "test-volume";
          target = "/my-volume";
        }
        {
          volumeName = "test-volume2";
          target = "/my-volume2";
        }
        {
          volumeName = "test-volume3";
          target = "/my-volume3";
        }
      ];

    };

    volumes = {
      test = { };
    };

  };

}
