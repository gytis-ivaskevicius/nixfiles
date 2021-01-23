{ stdenv, fetchFromGitHub, pkgs }:

# To make use of this derivation, use
# `programs.zsh.interactiveShellInit = "source ${pkgs.zsh-forgit}/share/zsh-forgit/forgit.plugin.zsh";

stdenv.mkDerivation rec {
  pname = "forgit";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = "95526b3130c53bba22f8997b9b2f840ea3632a2f";
    sha256 = "8dpHcFiybHZYBh3Oo9QJ27M9dXe7neJcS3yvK12yD1g=";
  };

  installPhase = ''
    install -D forgit.plugin.zsh --target-directory=$out/share/zsh-forgit
  '';
}
