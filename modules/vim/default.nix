{ config, pkgs, lib, packageOverrides, ... }:

let custom_nvim = pkgs.neovim.override {
  viAlias = true;
  vimAlias = true;
  withNodeJs = true;

  configure = {
    customRC = builtins.readFile ./init.vim;
    plug.plugins = with pkgs.vimPlugins; [

    ];
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [ vim-nix ];
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

