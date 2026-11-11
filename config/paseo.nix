{ pkgs, lib, ... }:

let
  # `pi` (and `sg`) are installed via bun's global bin dir, which is neither a
  # Nix profile nor otherwise on the daemon's PATH.
  bunBin = "/home/gytis/.cache/.bun/bin";

  # Same list paseo's module computes, plus bun's bin dir. The module sets PATH
  # with mkForce, so this uses mkOverride 40 to take precedence over it; without
  # it, terminals and sub-agents spawned by the daemon (bare `pi`) can't find pi.
  paseoPath = lib.concatStringsSep ":" [
    bunBin
    "/home/gytis/.nix-profile/bin"
    "/home/gytis/.local/state/nix/profile/bin"
    "/etc/profiles/per-user/gytis/bin"
    "/run/current-system/sw/bin"
    "/run/wrappers/bin"
    "/nix/var/nix/profiles/default/bin"
  ];
in
{
  services.paseo = {
    enable = true;
    package = pkgs.paseo;
    user = "gytis";
    group = "users";
    settings.features.webUi.enabled = true;

    environment.PI_COMMAND = "${bunBin}/pi";

    # pi and its voice recorder run under this daemon, not a shell, so they get
    # none of the user's shell env. @handy-computer/recorder links libasound.so.2
    # by bare soname, and NixOS has no /etc/ld.so.cache for it.
    environment.LD_LIBRARY_PATH = "${pkgs.libpulseaudio}/lib:${pkgs.alsa-lib}/lib";
  };

  systemd.services.paseo.environment.PATH = lib.mkOverride 40 paseoPath;
}
