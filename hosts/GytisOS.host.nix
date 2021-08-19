{ config, builtins, lib, pkgs, modulesPath, ... }:

{

  boot.kernelParams = [ "idle=nomwait" "processor.max_cstate=5" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];

  fileSystems."/" = { device = "zroot/locker/os"; fsType = "zfs"; };
  fileSystems."/home" = { device = "zroot/locker/home"; fsType = "zfs"; };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/F794-3014"; fsType = "vfat"; };
  fileSystems."/nix" = { device = "zroot/locker/nix"; fsType = "zfs"; };

  environment.systemPackages = [ pkgs.chromium ];

  services.tailscale.enable = true;

  environment.shellAliases = {
    vv = "${pkgs.neovim-unwrapped}/bin/nvim";
  };


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
      "gcbommkclmclpchllfjekcdonpmejbdp" # Https everywhere
      "gneobebnilffgkejpfhlgkmpkipgbcno" # Death To _blank
      "hokcepcfcicnhalinladgknhaljndhpc" # Witchcraft
      "iipjdmnoigaobkamfhnojmglcdbnfaaf" # Clutter Free - Prevent duplicate tabs
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
