{ pkgs, lib, ... }:

{
  #services.tailscale.enable = true;
  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "9bee8941b5c7428a" "12ac4a1e710088c5" ];

  users.extraUsers.gytis = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Gytis Ivaskevicius";
    extraGroups = [ "audio" "video" "dialout" "adbusers" "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "toor";
  };

  users.extraUsers.guest = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Guest user";
    extraGroups = [ "wheel" ];
    initialPassword = "toor";
  };
}
