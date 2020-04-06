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
    gitAndTools.diff-so-fancy
    ack
    binutils
    curl
    docker_compose
    exa
    fasd
    fd
    file
    fzf
    git
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
