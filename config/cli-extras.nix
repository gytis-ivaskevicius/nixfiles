{ pkgs, lib, ... }:
{

  programs.adb.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    android-file-transfer
    appimage-run
    binutils
    dmidecode
    dnsutils
    ffmpeg
    g-lf
    inetutils
    manix
    mediainfo
    neofetch
    nix-index
    nmap
    ntfs3g
    openssl
    patchelf
    rclone
    sshfs
    sshpass
    sshuttle
    steam-run
    tmux
    usbutils
    yt-dlp
  ];
}
