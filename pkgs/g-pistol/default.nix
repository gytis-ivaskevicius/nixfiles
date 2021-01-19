{ pkgs
, pistol
, bat
, mediainfo
, batTheme ? "base16"
}:
let
  b = "${bat}/bin/bat --paging=never --plain --theme=${batTheme} --color=always";
  f = "%pistol-filename%";
  pistol-config = pkgs.writeText "pistol.conf" ''
    ^(video|image|audio)/*            ${mediainfo}/bin/mediainfo ${f}
    application/csv                   column -s, -t ${f}
    application/json                  ${b} ${f}
    text/plain                        ${b} ${f}

    fpath .*.(kt|kts|properties)$     ${b} ${f}
    fpath .*.(pom|iml)$               ${b} --language xml ${f}
    fpath .*.(repositories|sha1)$     ${b} --language properties ${f}
    fpath .*.jmod                     jmod list ${f}
    fpath gradlew                     ${b} ${f}

    fpath .*.(7z)$                    7z l ${f}
    fpath .*.(iso)$                   iso-info --no-header -l ${f}
    fpath .*.(o)$                     nm ${f} | less
    fpath .*.(rar)$                   unrar l ${f}
    fpath .*.(tar)$                   tar tf ${f}
    fpath .*.(tar.bz2|tbz2)$          tar tjf ${f}
    fpath .*.(tar.txz|txz)$           xz --list ${f}
    fpath .*.(tgz|tar.gz)$            tar tzf ${f}
    fpath .*.(zip|jar|war|ear|oxt)$   unzip -l ${f}
    fpath .*.[1-8]$                   man ${f} | col -b
  '';
  wrapped = pkgs.writeShellScriptBin "pistol" "${pistol}/bin/pistol --config ${pistol-config} $@";
in
pkgs.symlinkJoin {
  name = "pistol";
  paths = [
    wrapped
    pistol
  ];
}
