{ config, pkgs, ... }:

{
  imports =
    [
    ./packages/sxhkd/sxhkd.nix
      ./hardware-configuration.nix
      ./desktops/i3rice.nix
      ./commons/nixos.nix
      ./commons/fonts.nix
      ./commons/networkmanager.nix
      ./commons/systemdboot.nix
      ./commons/command-line-utils.nix
      ./commons/docker.nix
      ./commons/print.nix
      ./users/test.nix
    ];

  programs.git = {
    enable = true;
    userName  = "Gytis I.";
    userEmail = "gyits02.21@gmail.com";
  };

  fileSystems."/tmp" = {
    fsType = "tmpfs";
    device = "tmpfs";
    options = [ "nosuid" "nodev" "relatime" "size=14G" ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    opengl.driSupport32Bit = true;
  };

  networking.extraHosts =
    ''
    127.0.0.1 localhost 
    '';

  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    docker_compose
      jq
      ulauncher
      libnotify
      vault
      vlc
      ack
      arandr
      autorandr
      dunst
      exa
      feh
      flameshot
      inetutils
      lightdm
      lshw
      man
      gnome3.nautilus
      neofetch
      neovim
      nettools
      networkmanagerapplet
      noto-fonts
      noto-fonts-emoji
      pantheon.pantheon-agent-polkit
      papirus-icon-theme
      ranger
      sxhkd
      termite
      tlp
      unzip
      vlc
      wmctrl
      xclip
      xdotool
      fzf zsh oh-my-zsh ripgrep neofetch tmux playerctl fasd jq mosh psmisc ranger nix-index mpv youtube-dl file fd
      git
      binutils gcc gnumake openssl pkgconfig pciutils usbutils lm_sensors
      pavucontrol pywal pithos
      steam mesa 
      zathura mumble feh mplayer slack firefox grip 
      ];
  services.openssh.enable = true;



}
