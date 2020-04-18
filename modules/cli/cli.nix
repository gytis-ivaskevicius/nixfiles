{ config, pkgs, lib, ... }:
{

	environment.variables = {
		EDITOR = "nvim";
		VISUAL = "nvim";
		BROWSER = "firefox";
		TERM = "xterm-256color";
	};

	programs.zsh = {
		autosuggestions.enable = true;
		enable = true;
		enableCompletion = true;
		histFile = "$HOME/.cache/.zsh_history";
		histSize = 1000000;
		ohMyZsh.enable = true;
		ohMyZsh.theme = "avit";
		syntaxHighlighting.enable = true;

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

	environment.shellAliases.grep="grep --color=auto";
	environment.shellAliases.diff="diff --color=auto";

	environment.shellAliases.burn="pkill -9";
	environment.shellAliases.external-ip="dig +short myip.opendns.com @resolver1.opendns.com";
	environment.shellAliases.f="find . | grep ";
	environment.shellAliases.killall="pkill";
	environment.shellAliases.less="$PAGER";
	environment.shellAliases.q="exit";
	environment.shellAliases.sc="sudo systemctl";
	environment.shellAliases.scu="systemctl --user ";
	environment.shellAliases.svi="sudo $EDITOR";
	environment.shellAliases.ufw="sudo ufw";

	environment.shellAliases.cp="cp -i";
	environment.shellAliases.ln="ln -i";
	environment.shellAliases.mkdir="mkdir -p";
	environment.shellAliases.mv="mv -i";
	environment.shellAliases.rm="rm -Iv --preserve-root";
	environment.shellAliases.wget="wget -c";


	environment.shellAliases.c="xclip -selection clipboard";
	environment.shellAliases.cm="xclip"; # Copy to middle click clipboard
	environment.shellAliases.l="ls -lF --time-style=long-iso";
	environment.shellAliases.la="l -a";
	environment.shellAliases.ls="exa -h --git --color=auto --group-directories-first -s extension";
	environment.shellAliases.lstree="ls --tree";
	environment.shellAliases.tree="lstree";

	environment.shellAliases.".."="cd ..";
	environment.shellAliases."..."="cd ../../";
	environment.shellAliases."...."="cd ../../../";
	environment.shellAliases."....."="cd ../../../../";
	environment.shellAliases."......"="cd ../../../../../";

	environment.systemPackages = with pkgs; [
		ack
		binutils
		curl
		dmidecode
		docker_compose
		entr
		exa
		fasd
		fd
		ffmpeg
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
		nettools
		nix-index
		nmap
		ntfs3g
		parted
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
		mediainfo
	];


}
