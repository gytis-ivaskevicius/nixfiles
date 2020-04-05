{ config, pkgs, ... }:

{

  environment = {
    systemPackages = with pkgs; [
          xclip fzf tmux tldr
          gitAndTools.gitFull gitAndTools.diff-so-fancy gitAndTools.hub tig
          zip unzip
          openssl gnupg
          htop 
          file tree dialog
          telnet
          pciutils usbutils
        ];
  };
  programs.zsh.enable = true;
}
