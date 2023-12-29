{ config, pkgs, lib, inputs, ... }:
{

  environment.variables = {
    EDITOR = "nvim";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
  };

  users.defaultUserShell = lib.getExe pkgs.zsh;

  programs.zsh = {
    enableBashCompletion = true;
    autosuggestions.enable = true;
    autosuggestions.extraConfig.ZSH_AUTOSUGGEST_USE_ASYNC = "y";
    enable = true;
    enableCompletion = true;
    histFile = "$HOME/.cache/.zsh_history";
    histSize = 100000;
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "root" "line" ];
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "sudo" "z" "aws" ];
    shellInit = ''
      source ${pkgs.zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh
    '';
    promptInit = ''
      ${builtins.readFile (pkgs.shell-config.override { dockerAliasEnabled = config.virtualisation.docker.enable; })}
      autoload -U promptinit && promptinit && prompt pure
      complete -o nospace -C ${pkgs.nomad}/bin/nomad nomad
      complete -o nospace -C ${pkgs.consul}/bin/consul consul
      complete -o nospace -C ${pkgs.vault-bin}/bin/vault vault
      complete -o nospace -C ${pkgs.terraform}/bin/terraform terraform
      complete -o nospace -C ${pkgs.awscli}/bin/aws_completer aws
    '';

    setOptions = [
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
      "NOAUTOMENU"
      "NOMENUCOMPLETE"
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
    nixpkgs-fmt
    nushell
    p7zip
    parted
    pciutils
    psmisc
    pure-prompt
    ranger
    ripgrep
    unzip
    wget
    which
    zip
  ];
}
