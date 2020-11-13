{ stdenv, pkgs }:

let
  pistol-config = pkgs.writeText "pistol.conf" ''
    ^(video|image|audio)/* mediainfo %pistol-filename%
    application/csv column -s, -t %pistol-filename%
    application/json bat --paging=never --plain --theme=base16 --color=always %pistol-filename%
    text/plain bat --paging=never --plain --theme=base16 --color=always %pistol-filename%

    fpath .*.(kt|kts|properties)$ bat --paging=never --plain --theme=base16 --color=always %pistol-filename%
    fpath .*.(pom|iml)$ bat --language xml --paging=never --plain --theme=base16 --color=always %pistol-filename%
    fpath .*.(repositories|sha1)$ bat --language properties --paging=never --plain --theme=base16 --color=always %pistol-filename%
    fpath .*.jmod jmod list %pistol-filename%
    fpath gradlew bat --paging=never --plain --theme=base16 --color=always %pistol-filename%

    fpath .*.(7z)$ 7z l %pistol-filename%
    fpath .*.(iso)$ iso-info --no-header -l %pistol-filename%
    fpath .*.(o)$ nm %pistol-filename% | less
    fpath .*.(rar)$ unrar l %pistol-filename%
    fpath .*.(tar)$ tar tf %pistol-filename%
    fpath .*.(tar.bz2|tbz2)$ tar tjf %pistol-filename%
    fpath .*.(tar.txz|txz)$ xz --list %pistol-filename%
    fpath .*.(tgz|tar.gz)$ tar tzf %pistol-filename%
    fpath .*.(zip|jar|war|ear|oxt)$ unzip -l %pistol-filename%
    fpath .*.[1-8]$ man %pistol-filename% | col -b
  '';
in
  pkgs.writeShellScriptBin "preview" "${pkgs.pistol}/bin/pistol --config ${pistol-config} $@"
