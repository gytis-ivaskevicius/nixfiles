{ config, builtins, lib, pkgs, modulesPath, ... }:

{

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "tank/locker/os";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "tank/locker/home";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    {
      device = "tank/locker/nix";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/D90A-71C8";
      fsType = "vfat";
    };


  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  environment.variables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
    BROWSER = "brave";
    TERMINAL = "alacritty";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  nix.settings.max-jobs = 128;
  nix.settings.cores = 32;

  environment.systemPackages = with pkgs; [
    #exodus
    alsa-utils
    brave
    brightnessctl
    bun
    cargo-llvm-cov
    cargo-mutants
    deno
    discord
    discord-for-poor-people
    dotnet-sdk_8
    element-for-poor-people
    eog
    gnumake
    helix
    just
    maki
    mono
    nodejs
    opencode
    paseo-desktop
    pavucontrol
    playerctl
    prismlauncher
    rustup
    uv
    vlc
    vscode
    xdg-utils # Multiple packages depend on xdg-open at runtime. This includes Discord and JetBrains
  ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  networking.firewall.checkReversePath = "loose";
  programs.steam.enable = true;

  environment.shellAliases = {
    vv = "${pkgs.neovim-unwrapped}/bin/nvim";
  };
  #programs.noisetorch.enable = true;


  security.chromiumSuidSandbox.enable = true;
  programs.chromium = {
    # defaultSearchProviderSuggestURL = "https://encrypted.google.com/complete/search?output=chrome&q={searchTerms}";
    # defaultSearchProviderSearchURL = "https://encrypted.google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}{google:instantExtendedEnabledParameter}ie={inputEncoding}";
    # https://chromeenterprise.google/policies
    enable = true;
    homepageLocation = "https://github.com/notifications";

    extraOpts = {
      CloudPrintSubmitEnabled = false;
      EnableMediaRouter = false;
      HideWebStoreIcon = true;
      MetricsReportingEnabled = false;
      NewTabPageLocation = "https://github.com/notifications";
      PasswordManagerEnabled = false;
      RestoreOnStartup = 1; # 5 = Open New Tab Page 1 = Restore the last session 4 = Open a list of URLs
      SpellcheckEnabled = true;
      SpellcheckLanguage = [ "lt" "en-US" ];
      WelcomePageOnOSUpgradeEnabled = false;
    };

  };
}
