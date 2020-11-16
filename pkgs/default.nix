self: super: rec {
  g-pistol = super.callPackage ./g-pistol { };
  g-neovim = super.callPackage ./g-neovim { };
  g-termite = super.callPackage ./g-termite { };
  g-rofi = super.callPackage ./g-rofi { };
}
