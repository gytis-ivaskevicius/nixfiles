{ pkgs, ... }:

{
  services.paseo = {
    enable = true;
    user = "gytis";
    group = "users";
    relay.enable = false;
    settings.features.webUi.enabled = true;
    package = pkgs.paseo;

    # `pi` is installed via bun's global bin dir, which is NOT on the daemon's
    # PATH (the module only adds NixOS/home-manager profile paths). Point the
    # built-in "pi" provider at the binary explicitly so paseo can find it.
    environment.PI_COMMAND = "/home/gytis/.cache/.bun/bin/pi";
  };
}
