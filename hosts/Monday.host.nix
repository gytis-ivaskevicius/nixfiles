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

  programs.ssh.startAgent = true;
  programs.dconf.enable = true;

  gytix.cachix.enable = true;

  hardware.bluetooth.enable = true;
  environment.variables = {
    BROWSER = "chromium";
    TERMINAL = "alacritty";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  nix.settings.max-jobs = 128;
  nix.settings.cores = 32;

  environment.systemPackages = with pkgs; [
    vscode
    code-cursor
    playerctl
    alsa-utils
    brightnessctl
    remmina
    brave
    discord
    firefox
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
