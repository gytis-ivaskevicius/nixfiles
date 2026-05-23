{ pkgs, ... }: {
  programs = {
    # Enable Steam Game
    # Gamescope session inside game.
    # gamemoderun gamescope -W 2560 -H 1440 -r 60 --mangoapp -f -b --force-grab-cursor -- %command%
    # dont use -F fsr, if its crashing on launch.
    # dont use -e, game will be hidden.
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession = {
        # Optimized micro-compositor. Use the Steam launch option: gamescope %command%
        enable = true;
      };
      package = pkgs.steam.override {
        extraPkgs = pkgs':
          with pkgs'; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib # Provides libstdc++.so.6
            libkrb5
            keyutils
            # Add other libraries as needed
          ];
      };
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    # Gamemode
    gamemode = {
      # Feral Interactive optimizations. Use Steam launch option: gamemoderun %command%
      enable = true;
      settings = { };
      enableRenice = true;
    };
    # Gamescope, Dont use separate gamescope as this is causing steam gamescopeSession issue.
    # gamescope = {
    #   enable = true;
    #   package = pkgs.gamescope;
    #   capSysNice = true;
    # };
  };

  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    steam-run
    sgdboop # steamgriddb
    mangohud

    # Roms Manager
    steam-rom-manager

    # PS
    pcsx2

    # Vulkan tools
    vulkan-tools
    mesa-demos

    # Additional tools
    libstrangle

    # RetroArch
    (retroarch.withCores (cores:
      with cores; [
        mesen
        ppsspp
        desmume
      ]))
  ];
}
