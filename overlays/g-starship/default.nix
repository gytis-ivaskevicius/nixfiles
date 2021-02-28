{ pkgs, starship }:
pkgs.runCommand "starship-zsh-init" { } ''
  echo "export STARSHIP_CONFIG=${./starship.toml}" > $out
  export STARSHIP_CACHE=$(pwd)
  ${starship}/bin/starship init zsh --print-full-init >> $out
''
