
{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.stateVersion = "19.09";
  programs.git.enable = true;

  programs.fzf.enableZshIntegration = true;
  imports = [ ./packages/nvim.nix ];

}
