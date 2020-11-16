self: super: rec {
  g-alacritty = super.callPackage ./g-alacritty { };
  g-neovim = super.callPackage ./g-neovim { };
  g-pistol = super.callPackage ./g-pistol { };
  g-rofi = super.callPackage ./g-rofi { };
  g-termite = super.callPackage ./g-termite { };
}
