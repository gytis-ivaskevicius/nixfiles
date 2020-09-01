{ config, pkgs, lib, packageOverrides, ... }:

let custom_nvim = pkgs.neovim.override {
  viAlias = true;
  vimAlias = true;
  withNodeJs = true;

  configure = {
    customRC = builtins.readFile ./init.vim;

    packages.neovim = with pkgs.vimPlugins; {
      start = [
        vim-plug
        vim-nix
      ];
      # To automatically load a plugin when opening a filetype, add vimrc lines like:
      # autocmd FileType php :packadd phpCompletion
      opt = [ ];
    };      
  };
};
in {

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    environment.shellAliases = {
      svi="sudo $EDITOR";
    };

    environment.systemPackages = with pkgs; [ custom_nvim ];
  }

