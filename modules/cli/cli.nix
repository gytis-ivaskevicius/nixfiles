{ config, pkgs, lib, ... }:
{

	environment.variables = {
		EDITOR = "nvim";
		VISUAL = "nvim";
		TERM = "xterm-256color";
		LC_ALL = "en_US.UTF-8";
	};

    programs.adb.enable = true;
	programs.zsh = {
		autosuggestions.enable = true;
		enable = true;
		enableCompletion = true;
		histFile = "$HOME/.cache/.zsh_history";
		histSize = 1000000;
		syntaxHighlighting.enable = true;
		ohMyZsh.enable = true;

		promptInit = ''
			autoload -U promptinit; promptinit
			prompt pure
			'';

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
		personal="$EDITOR ~/personal.nix";

		burn="pkill -9";
		external-ip="dig +short myip.opendns.com @resolver1.opendns.com";
		f="find . | grep ";
		killall="pkill";
		less="$PAGER";
		q="exit";
		sc="sudo systemctl";
		scu="systemctl --user ";
		svi="sudo $EDITOR";
		vi="$EDITOR";
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
		cargo
		cmake
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
		gcc
		git
		gitAndTools.diff-so-fancy
		gnumake
		htop
		iftop
		inetutils
		iotop
		jq
		lf
		libnotify
		lm_sensors
		lshw
		man
		mediainfo
		neofetch
		neovim
		nettools
		nix-index
		nmap
		ntfs3g
		openssl
		parted
		patchelf
		pciutils
		psmisc
		psmisc # killall
		python
		ranger
		rclone
		ripgrep
		ripgrep
		sshfs
		sshpass
		steam-run
		telnet
		tmux
		tmux
		unstable.pure-prompt
		unzip
		usbutils
		vimPlugins.vim-plug
		wget
		which
		youtube-dl
		zip
	];
}
