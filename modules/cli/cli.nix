{ config, pkgs, lib, ... }:
{


  programs.zsh = {
	autosuggestions.enable = true;
	#autosuggestions.extraConfig
	enableCompletion = true;
	#enableGlobalCompInit
	histFile = "$HOME/.cache/.zsh_history";
	histSize = 1000000;
	#setOptions
	#shellAliases
	#shellInit
	syntaxHighlighting.enable = true;
  	enable = true;
	ohMyZsh.enable = true;
	ohMyZsh.theme = "pure";
  };

environment.systemPackages = with pkgs; [
    ack
    binutils
    curl
    docker_compose
    entr
    exa
    fasd
    fd
    file
    fzf
    git
    gitAndTools.diff-so-fancy
    htop
    iftop
    inetutils
    iotop
    jq
    libnotify
    lm_sensors
    lshw
    man
    neofetch
    neovim
    neovim
    nettools
    nix-index
    pciutils
    psmisc
    psmisc # killall
    ranger
    ripgrep
    ripgrep
    telnet
    tmux
    tmux
    unzip
    usbutils
    wget
    which
    youtube-dl
  ];

	
}
