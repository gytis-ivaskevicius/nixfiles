{ pkgs, lib, config, ... }:

{

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    nix-direnv = {
      enable = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
    NIXPKGS_ALLOW_UNFREE = 1;
  };


  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "plain";
      paging = "never";
    };

    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
    ];
  };

  home.packages = with pkgs; [
    curl
    entr
    eza
    fd
    file
    fup-repl
    fzf
    gcc
    git
    git-lfs
    github-cli
    htop
    inetutils
    iotop
    jq
    lm_sensors
    lshw
    lsof
    nettools
    nix-top
    nix-tree
    nix2vimDemo
    nixfmt-rfc-style
    nixpkgs-fmt
    nushell
    p7zip
    parted
    pciutils
    psmisc
    pure-prompt
    ranger
    ripgrep
    statix
    unzip
    wget
    which
    zip
    chatgpt-cli

    # from cli-extras.nix
    binutils
    comma
    dmidecode
    dnsutils
    ffmpeg
    g-lf
    ijq
    manix
    mediainfo
    neofetch
    nix-index
    nmap
    ntfs3g
    openssl
    patchelf
    python3
    rclone
    sshfs
    sshpass
    sshuttle
    steam-run
    tmate
    tmux
    usbutils
    yt-dlp
    zellij
  ];


  #programs.zsh.enable = true;
  home.shellAliases = {
    man = "batman --paging=auto";
    ga = "git add";
    gc = "git commit";
    gcm = "git commit -m";
    gs = "git status";
    gsb = "git status -sb";
    grep = "grep --color=auto";
    diff = "batdiff";
    nixos-rebuild = "sudo nixos-rebuild";
    auto-nix-rebuild = "ls /etc/nixos/**/*.nix | entr sudo bash -c 'nixos-rebuild switch && printf \"DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n\"'";
    personal = "sudo $EDITOR /etc/nixos/personal.nix";
    opt = "manix '' | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | fzf --ansi --preview=\"manix '{}' | sed 's/type: /> type: /g' | bat -l Markdown --color=always --plain\"";

    burn = "pkill -9";
    external-ip = "dig +short myip.opendns.com @resolver1.opendns.com";
    v = "$EDITOR $(fzf)";
    sv = "sudo $EDITOR $(fzf)";
    killall = "pkill";
    q = "exit";
    sc = "sudo systemctl";
    scu = "systemctl --user ";
    svi = "sudo $EDITOR";
    net = "ip -c -br addr";

    mkdir = "mkdir -p";
    rm = "rm -Iv --preserve-root";
    wget = "wget -c";

    c = "xclip -selection clipboard";
    cm = "xclip"; # Copy to middle click clipboard
    l = "ls -lF --time-style=long-iso";
    la = "l -a";
    ls = "eza --color=auto --group-directories-first -s name";
    lstree = "ls --tree";
    tree = "lstree";

    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";
  };

  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; map (it: { inherit (it) src; name = it.pname; }) [
      pure
      z
      forgit
      nvm
      fzf
      forgit
      fish-you-should-use
      autopair
    ];
    interactiveShellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
  };


  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true; # Replaces AUTO_CD in setOptions

    # History configuration - converted from individual options
    history = {
      size = 100000; # Was histSize
      save = 100000; # Should match size
      path = "$HOME/.cache/.zsh_history"; # Was histFile
      extended = true; # EXTENDED_HISTORY
      ignoreDups = true; # HIST_IGNORE_DUPS
      ignoreAllDups = true; # HIST_IGNORE_ALL_DUPS
      ignoreSpace = true; # HIST_IGNORE_SPACE
      findNoDups = true; # HIST_FIND_NO_DUPS
      saveNoDups = true; # HIST_SAVE_NO_DUPS
      expireDuplicatesFirst = true; # HIST_EXPIRE_DUPS_FIRST
      share = true; # SHARE_HISTORY
      append = true; # INC_APPEND_HISTORY
    };
    dotDir = "${config.xdg.configHome}/zsh";

    # Autosuggestions - structure changed
    autosuggestion = {
      enable = true; # Was autosuggestions.enable
    };

    # Syntax highlighting - same structure
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" "root" "line" ];
    };

    # Oh-My-Zsh - hyphenated name
    oh-my-zsh = {
      enable = true; # Was ohMyZsh.enable
      plugins = [ "sudo" "z" "aws" ]; # Was ohMyZsh.plugins
      theme = "";
    };

    # Shell initialization - combined into initExtra
    initContent = ''
      source ${pkgs.pure-prompt}/share/zsh/site-functions/async
      source ${pkgs.pure-prompt}/share/zsh/site-functions/prompt_pure_setup
      # From shellInit
      source ${pkgs.zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh
      chat() {
        echo
        ${lib.getExe pkgs.chatgpt-cli} "$@" | ${lib.getExe pkgs.bat} --language=md --decorations=never --paging=never
      }

      # From promptInit
      ${builtins.readFile (pkgs.shell-config.override {
        dockerAliasEnabled = true;
      })}
      source ~/.zshrc

      # Remaining setOptions that don't have dedicated options
      setopt BANG_HIST
      setopt HIST_REDUCE_BLANKS
      setopt NOAUTOMENU
      setopt NOMENUCOMPLETE

      # ZSH_AUTOSUGGEST_USE_ASYNC from autosuggestions.extraConfig
      export ZSH_AUTOSUGGEST_USE_ASYNC=y
    '';
  };

}
