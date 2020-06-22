{ config, lib, pkgs, ... }:
{

  services.kubernetes = {
    roles = [ "master" "node" ];
    kubelet.extraOpts = "--fail-swap-on=false";
    easyCerts = true;
    addonManager.enable = true;
    addons.dashboard.enable = true;
    masterAddress = "kuber.shitties";
#    addons.dns.enable = true;
#    apiserver.enable = true;
  };
}

