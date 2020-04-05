{ config, lib, pkgs, ... }:

{
  users.extraUsers.test = {
    isNormalUser = true;
    description = "Test acc";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "toor";
    uid = 1000;
  };
}
