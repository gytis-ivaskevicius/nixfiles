{ pkgs, lib, ... }:
{

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    #android-file-transfer
    binutils
    direnv
    dmidecode
    dnsutils
    ffmpeg
    g-lf
    ijq
    manix
    mediainfo
    neofetch
    nix-index
    nmap
    ntfs3g
    openssl
    patchelf
    python3
    rclone
    sshfs
    sshpass
    sshuttle
    steam-run
    tmate
    tmux
    usbutils
    yt-dlp
    zellij
  ];
}
