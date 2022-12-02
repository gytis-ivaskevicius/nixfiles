{ config, builtins, lib, pkgs, modulesPath, ... }:

{

  boot.kernelParams = [ "idle=nomwait" "processor.max_cstate=5" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];

  fileSystems."/boot" = { device = "/dev/disk/by-uuid/1E86-D505"; fsType = "vfat"; };
  fileSystems."/" = { device = "/dev/disk/by-uuid/1a61535f-0099-415b-af78-51913eb9e4d2"; fsType = "ext4"; };

  imports = [
    #./work/modules.nix
    #./work/i3rice.nix
  ];

  programs.ssh.startAgent = true;
  programs.dconf.enable = true;


  hardware.bluetooth.enable = true;
  environment.variables = {
    BROWSER = "brave";
    TERMINAL = "alacritty";
  };

  environment.systemPackages = with pkgs; [
    brave
    discord
    firefox
    g-alacritty
    gnome3.eog
    pavucontrol
    vlc
    xdg-utils # Multiple packages depend on xdg-open at runtime. This includes Discord and JetBrains
    pulseaudio
    chromium
    #exodus
    discord-for-poor-people
    element-for-poor-people
    rnix-lsp
    distrobox
    obs-studio
    tdesktop
    prismlauncher
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
    homepageLocation = "about:blank";

    extensions = [
      "chklaanhfefbnpoihckbnefhakgolnmc" # JSONView
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "ckkdlimhmcjmikdlpkmbgfkaikojcbjk" # Markdown Viewer
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium.
      #"eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "fdjamakpfbbddfjaooikfcpapjohcfmg" # Dashlane
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
      NewTabPageLocation = "about:blank";
      PasswordManagerEnabled = false;
      RestoreOnStartup = 1; # 5 = Open New Tab Page 1 = Restore the last session 4 = Open a list of URLs
      SpellcheckEnabled = true;
      SpellcheckLanguage = [ "lt" "en-US" ];
      WelcomePageOnOSUpgradeEnabled = false;
    };

  };
}
