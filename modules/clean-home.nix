{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.gytix.cleanHome;
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_DATA_HOME = "$HOME/.local/share";
in
{
  options = {
    gytix.cleanHome.enable = mkEnableOption "Enable environment variables to reduce clutter in $HOME";


    gytix.cleanHome.variables = lib.mkOption {
      default = {
        ANDROID_AVD_HOME = "${XDG_CONFIG_HOME}/android";
        ANDROID_SDK_HOME = "${XDG_CONFIG_HOME}/android";
        ANSIBLE_CONFIG = "${XDG_CONFIG_HOME}/ansible/ansible.cfg";
        CARGO_HOME = "${XDG_DATA_HOME}/cargo";
        ERRFILE = "${XDG_CACHE_HOME}/.xsession-errors";
        GOPATH = "${XDG_DATA_HOME}/go";
        GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
        GTK2_RC_FILES = "${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0";
        HISTFILE = "${XDG_CACHE_HOME}/history";
        INPUTRC = "${XDG_CONFIG_HOME}/inputrc";
        LESSHISTFILE = "-";
        MINIKUBE_HOME = "${XDG_CONFIG_HOME}/minikube";
        XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
        XCOMPOSEFILE = "${XDG_CONFIG_HOME}/X11/xcompose";
        ZDOTDIR = "${XDG_CONFIG_HOME}/zsh";
        #TMUX_TMPDIR="$XDG_RUNTIME_DIR";
        #WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc";
        #XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"; # This line will break some DMs.
      };
      type = with types; attrsOf (either str (listOf str));
    };
  };

  config = mkIf cfg.enable {
    environment.variables = cfg.variables;
  };
}
