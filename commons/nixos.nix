{ config, lib, pkgs, ... }:

{
  imports = [ ./nixos-upgrade.nix ];
  system = {
    stateVersion = "19.03";
  };
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 20d";
    dates = "Mon 12:00:00";
  };
  nix.allowedUsers = [ "@users" ];
  nix.autoOptimiseStore = true;

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };

  security.sudo = {
    enable = true;
  };

# services.usbguard = {
#   enable = true;
#   # Generate a file with
#   #   $ sudo usbguard generate-policy > commons/usbguard.rules
#   rules = lib.readFile ./usbguard.rules;
#   IPCAllowedGroups = [ "wheel" ];
# };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Budapest";

  programs.bash.enableCompletion = true;
  boot.tmpOnTmpfs = true;
}
