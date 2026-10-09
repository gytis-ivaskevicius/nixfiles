{ pkgs, lib, ... }:

{
  #services.tailscale.enable = true;

  nix.settings.trusted-users = [ "gytis" ];

  users.extraUsers.gytis = {
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    isNormalUser = true;
    description = "Gytis Ivaskevicius";
    extraGroups = [
      "audio"
      "video"
      "dialout"
      "adbusers"
      "wheel"
      "networkmanager"
      "docker"
      "vboxusers"
      "libvirt"
      "libvirtd"
      "kvm"
    ];
    initialPassword = "toor";
  };

  users.extraUsers.guest = {
    shell = pkgs.zsh;
    isNormalUser = true;
    ignoreShellProgramCheck = true;
    description = "Guest user";
    extraGroups = [ "wheel" ];
    initialPassword = "toor";
  };

  environment.systemPackages = with pkgs; [ ];

}
