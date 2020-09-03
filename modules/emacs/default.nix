{ config, pkgs, lib, ... }:
{
  services.emacs.enable = true;
  services.emacs.install = true;
  #services.emacs.package = pkgs.emacsGit;
}
