{ pkgs, ... }:

{
  services.paseo = {
    enable = true;
    user = "gytis";
    group = "users";
    relay.enable = false;
    settings.features.webUi.enabled = true;
    package = pkgs.paseo;
  };
}
