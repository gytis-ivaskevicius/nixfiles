{ config, pkgs, lib, ... }:
{

  environment.variables = {
    EDITOR = "nvim";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
  };

  programs.adb.enable = lib.mkDefault true;

  programs.zsh = {
    autosuggestions.enable = true;
    enable = lib.mkDefault true;
    enableCompletion = true;
    histFile = "$HOME/.cache/.zsh_history";
    histSize = 100000;
    syntaxHighlighting.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "sudo" "z" ];

    interactiveShellInit = "source ${pkgs.zsh-forgit}/share/zsh-forgit/forgit.plugin.zsh";
    promptInit = builtins.readFile ./promptInit.zsh;

    setOptions = [
      "noautomenu"
      "nomenucomplete"
      "AUTO_CD"
      "BANG_HIST"
      "EXTENDED_HISTORY"
      "HIST_EXPIRE_DUPS_FIRST"
      "HIST_FIND_NO_DUPS"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_SPACE"
      "HIST_REDUCE_BLANKS"
      "HIST_SAVE_NO_DUPS"
      "INC_APPEND_HISTORY"
      "SHARE_HISTORY"
    ];

  };

  environment.shellAliases = {
    ga = "git add";
    gc = "git commit";
    gcm = "git commit -m";
    gs = "git status";
    gsb = "git status -sb";

    grep = "grep --color=auto";
    diff = "diff --color=auto";
    nixos-rebuild = "sudo nixos-rebuild";
    nix-repl = "nix repl '<nixpkgs>'";
    personal = "sudo $EDITOR /etc/nixos/personal.nix";
    opt = "manix '' | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | fzf --ansi --preview=\"manix '{}' | sed 's/type: /> type: /g' | bat -l Markdown --color=always --plain\"";

    burn = "pkill -9";
    external-ip = "dig +short myip.opendns.com @resolver1.opendns.com";
    f = "find . | grep ";
    v = "$EDITOR $(fzf)";
    sv = "sudo $EDITOR $(fzf)";
    killall = "pkill";
    q = "exit";
    sc = "sudo systemctl";
    scu = "systemctl --user ";
    svi = "sudo $EDITOR";
    net = "ip -c -br addr";

    cp = "cp -i";
    ln = "ln -i";
    mkdir = "mkdir -p";
    mv = "mv -i";
    rm = "rm -Iv --preserve-root";
    wget = "wget -c";

    c = "xclip -selection clipboard";
    cm = "xclip"; # Copy to middle click clipboard
    l = "ls -lF --time-style=long-iso";
    la = "l -a";
    ls = "exa -h --git --color=auto --group-directories-first -s extension";
    lstree = "ls --tree";
    tree = "lstree";

    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";
  };

  environment.systemPackages = with pkgs; [
    ack
    android-file-transfer
    appimage-run
    bat
    binutils
    cmake
    curl
    dmidecode
    dnsutils
    entr
    exa
    fd
    ffmpeg
    file
    fzf
    g-lf
    g-neovim
    gcc
    git
    gnumake
    htop
    iftop
    inetutils
    iotop
    jq
    libnotify
    lm_sensors
    lshw
    lsof
    man
    manix
    mediainfo
    neofetch
    nettools
    nix-index
    nix-tree
    nixpkgs-fmt
    nmap
    ntfs3g
    openssl
    p7zip
    parted
    patchelf
    pciutils
    psmisc
    pure-prompt
    python3
    python38Packages.pygments
    ranger
    rclone
    ripgrep
    sshfs
    sshpass
    sshuttle
    steam-run
    telnet
    tmux
    unzip
    usbutils
    wget
    which
    youtube-dl
    zip
  ];
}
