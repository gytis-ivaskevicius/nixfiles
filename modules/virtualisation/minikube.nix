{ config, lib, pkgs, ... }:
{

#  services.kubernetes = {
#   roles = ["master" "node"];
#   addons.dashboard.enable = true;
#   kubelet.extraOpts = "--fail-swap-on=false";
#   easyCerts = true;
#   masterAddress = "127.0.0.1";
#   masterAddress = "localhost";
#  };

    imports = [ ./virtualbox.nix ];
    environment.systemPackages = with pkgs; [
        minikube
        kubectl
    ];
}

