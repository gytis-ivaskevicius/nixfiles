
{ config, pkgs, ... }:

{
	environment.variables = {
		XDG_CACHE_HOME="$HOME/.cache";
		XDG_CONFIG_HOME="$HOME/.config";
		XDG_DATA_HOME="$HOME/.local/share";

		ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android";
		ANDROID_AVD_HOME="$XDG_CONFIG_HOME/android";
		ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg";
		CARGO_HOME="$XDG_DATA_HOME/cargo";
		ERRFILE="$XDG_CACHE_HOME/.xsession-errors";
		GNUPGHOME="$XDG_DATA_HOME/gnupg";
		GOPATH="$XDG_DATA_HOME/go";
		GRADLE_USER_HOME="$XDG_DATA_HOME/gradle";
		GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0";
		HISTFILE="$XDG_CACHE_HOME/history";
		INPUTRC="$XDG_CONFIG_HOME/inputrc";
		LESSHISTFILE="-";
		MINIKUBE_HOME="$HOME/.config/minikube";
		TMUX_TMPDIR="$XDG_RUNTIME_DIR";
		WGETRC="$XDG_CONFIG_HOME/wget/wgetrc";
		XCOMPOSECACHE="$XDG_CACHE_HOME/X11/xcompose";
		XCOMPOSEFILE="$XDG_CONFIG_HOME/X11/xcompose";
		ZDOTDIR="$XDG_CONFIG_HOME/zsh";
#		XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"; # This line will break some DMs.
	};

}
