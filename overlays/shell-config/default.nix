{ lib
, writeShellScript
, fd
, dockerAliasEnabled ? true
, nixArgsEnabled ? true
, nixAutocompleteFixEnabled ? true
, nixCdEnabled ? true
, prettyManPagesEnabled ? true
, promptEnabled ? true
, sshuttleEnabled ? true
, sshuttle
, starshipEnabled ? true
, starship
, zshPasteImprovementsEnabled ? true
}:


with lib;
let
  prettyManPages = ''
    export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
    export LESS_TERMCAP_md=$(tput bold; tput setaf 3)
    export LESS_TERMCAP_me=$(tput sgr0)
    export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
    export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
    export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2)
    export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)

    export LESS_TERMCAP_mr=$(tput rev)
    export LESS_TERMCAP_mh=$(tput dim)
    export LESS_TERMCAP_ZN=$(tput ssubm)
    export LESS_TERMCAP_ZV=$(tput rsubm)
    export LESS_TERMCAP_ZO=$(tput ssupm)
    export LESS_TERMCAP_ZW=$(tput rsupm)
  '';
  vpn = ''
    function vpn() {
        ${sshuttle}/bin/sshuttle --dns -r $1 0/0 --disable-ipv6 --no-latency-control
    }
  '';
  nix-cd = ''
    function nix-cd() {
      cd "$(nix eval -f '<nixpkgs>' --raw $1)"
    }
  '';
  docker = ''
    # Select a running docker container to stop
    function docker-stop() {
            local cid
            cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

            [ -n "$cid" ] && docker stop "$cid"
    }

    # Select a docker container to remove
    function docker-rm() {
            local cid
            cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

            [ -n "$cid" ] && docker rm "$cid"
    }

    # Select a container to attach onto with bash
    function docker-bash() {
            local cid
            cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

            [ -n "$cid" ] && docker container exec -it "$cid" /bin/bash
    }
  '';
  zshPasteImprovements = ''
    pasteinit() {
      OLD_SELF_INSERT=''${''${(s.:.)widgets[self-insert]}[2,3]}
      zle -N self-insert url-quote-magic
    }

    pastefinish() {
      zle -N self-insert $OLD_SELF_INSERT
    }

    zstyle :bracketed-paste-magic paste-init pasteinit
    zstyle :bracketed-paste-magic paste-finish pastefinish

    bindkey -r ^V
  '';
  starshipPrompt = ''
    export STARSHIP_CONFIG=${./starship.toml}
    eval "$(${starship}/bin/starship init zsh)"
  '';
in
writeShellScript "shellconfig.sh" ''
  if [ -n "''${commands[fzf-share]}" ]; then
    source "$(fzf-share)/key-bindings.zsh"
    source "$(fzf-share)/completion.zsh"
  fi

  ${optionalString dockerAliasEnabled docker}
  ${optionalString prettyManPagesEnabled prettyManPages}
  ${optionalString sshuttleEnabled vpn}
  ${optionalString nixArgsEnabled (builtins.readFile ./nix-args.sh)}
  ${optionalString nixCdEnabled nix-cd}
  ${optionalString nixAutocompleteFixEnabled (builtins.readFile ./nix-completions.sh)}
  ${optionalString zshPasteImprovementsEnabled zshPasteImprovements}
  ${optionalString starshipEnabled starshipPrompt}
''
