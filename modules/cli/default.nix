{ config, pkgs, lib, ... }:
{
  imports = [
    ../lf
  ];

  environment.variables = {
    TERM = "xterm-256color";
    LC_ALL = "en_US.UTF-8";
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
    ohMyZsh.plugins = [
      "git"
      "git-extras"
    ];

    promptInit = builtins.readFile ./promptInit.zsh;
    shellInit = builtins.readFile ./shellInit.zsh;

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
    grep="grep --color=auto";
    diff="diff --color=auto";
    nixos-rebuild="sudo nixos-rebuild";
    personal="sudoedit /etc/nixos/personal.nix";

    ccat="pygmentize";
    burn="pkill -9";
    external-ip="dig +short myip.opendns.com @resolver1.opendns.com";
    f="find . | grep ";
    killall="pkill";
    q="exit";
    sc="sudo systemctl";
    scu="systemctl --user ";
    ufw="sudo ufw";

    cp="cp -i";
    ln="ln -i";
    mkdir="mkdir -p";
    mv="mv -i";
    rm="rm -Iv --preserve-root";
    wget="wget -c";


    c="xclip -selection clipboard";
    cm="xclip"; # Copy to middle click clipboard
    l="ls -lF --time-style=long-iso";
    la="l -a";
    ls="exa -h --git --color=auto --group-directories-first -s extension";
    lstree="ls --tree";
    tree="lstree";

    ".."="cd ..";
    "..."="cd ../../";
    "...."="cd ../../../";
    "....."="cd ../../../../";
    "......"="cd ../../../../../";
  };

  environment.systemPackages = with pkgs; [
    ack
    android-file-transfer
    appimage-run
    binutils
    cmake
    curl
    dmidecode
    entr
    exa
    fd
    ffmpeg
    file
    fzf
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
    mediainfo
    neofetch
    nettools
    nix-index
    nixpkgs-fmt
    nmap
    ntfs3g
    openssl
    p7zip
    parted
    patchelf
    pciutils
    psmisc
    python3
    python38Packages.pygments
    ranger
    rclone
    ripgrep
    sshfs
    sshpass
    steam-run
    telnet
    tmux
    pure-prompt
    unzip
    usbutils
    wget
    which
    youtube-dl
    zip
     w3m ffmpegthumbnailer ueberzug bc highlight
  ];
}
