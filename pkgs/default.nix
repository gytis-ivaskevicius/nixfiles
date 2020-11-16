self: super: rec {
  preview = super.callPackage ./preview { };
  g-neovim = super.callPackage ./g-neovim { };
  g-termite = super.callPackage ./g-termite { };
  g-rofi = super.callPackage ./g-rofi { };
}
