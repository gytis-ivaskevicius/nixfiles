{ config, pkgs, lib, inputs, ... }: {

  environment.variables = {
    EDITOR = "nvim";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  users.defaultUserShell = lib.getExe pkgs.zsh;


  environment.shellAliases = {
    ga = "git add";
    gc = "git commit";
    gcm = "git commit -m";
    gs = "git status";
    gsb = "git status -sb";
    grep = "grep --color=auto";
    diff = "diff --color=auto";
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
    ls = "eza -h --git --color=auto --group-directories-first -s extension";
    lstree = "ls --tree";
    tree = "lstree";

    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";
  };

  environment.systemPackages = with pkgs; [
    bat
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
    man
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
  ];
}
