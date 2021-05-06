{ stdenv, srcs, pkgs }:

# To make use of this derivation, use
# `programs.zsh.interactiveShellInit = "source ${pkgs.zsh-forgit}/share/zsh-forgit/forgit.plugin.zsh";

stdenv.mkDerivation rec {
  pname = "forgit";
  version = "master";

  src = srcs.forgit-git;

  installPhase = ''
    install -D forgit.plugin.zsh --target-directory=$out/share/zsh-forgit
  '';
}
