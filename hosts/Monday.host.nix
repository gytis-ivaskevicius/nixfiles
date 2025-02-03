{ config, builtins, lib, pkgs, modulesPath, ... }:

{

  #boot.kernelParams = [ "idle=nomwait" "processor.max_cstate=5" ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];


  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/6f49f9e7-cc58-4e7c-b49e-e5b4b6e0a01b";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "discard=async" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/6f49f9e7-cc58-4e7c-b49e-e5b4b6e0a01b";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "discard=async" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/6f49f9e7-cc58-4e7c-b49e-e5b4b6e0a01b";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "discard=async" ];
    };

  fileSystems."/boot" =
    {
      label = "BOOT";
      fsType = "vfat";
    };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  programs.ssh.startAgent = true;
  programs.dconf.enable = true;

  gytix.cachix.enable = true;

  hardware.bluetooth.enable = true;
  environment.variables = {
    BROWSER = "brave";
    TERMINAL = "alacritty";
  };

  nix.settings.max-jobs = 128;
  nix.settings.cores = 128;

  environment.systemPackages = with pkgs; [
    remmina
    brave
    discord
    firefox
    g-alacritty
    eog
    pavucontrol
    vlc
    xdg-utils # Multiple packages depend on xdg-open at runtime. This includes Discord and JetBrains
    pulseaudio
    chromium
    #exodus
    discord-for-poor-people
    element-for-poor-people
    obs-studio
    tdesktop
    prismlauncher
    helix
  ];

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  programs.steam.enable = true;
  services.flatpak.enable = true;

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

    extensions = [
      "chklaanhfefbnpoihckbnefhakgolnmc" # JSONView
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "ckkdlimhmcjmikdlpkmbgfkaikojcbjk" # Markdown Viewer
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium.
      #"eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
      #"gcbommkclmclpchllfjekcdonpmejbdp" # Https everywhere
      "gneobebnilffgkejpfhlgkmpkipgbcno" # Death To _blank
      "hokcepcfcicnhalinladgknhaljndhpc" # Witchcraft
      #"iipjdmnoigaobkamfhnojmglcdbnfaaf" # Clutter Free - Prevent duplicate tabs
      "jfnifeihccihocjbfcfhicmmgpjicaec" # https://chrome.google.com/webstore/detail/gsconnect/jfnifeihccihocjbfcfhicmmgpjicaec
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
      "kljmejbpilkadikecejccebmccagifhl" # Image search options
      "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs
      "lifgeihcfpkmmlfjbailfpfhbahhibba" # Smart TOC
      "mgijmajocgfcbeboacabfgobmjgjcoja" # Google Dictionary (by Google)
      "opokoaglpekkimldnlggpoagmjegichg" # ViolentMonkey
    ];

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
