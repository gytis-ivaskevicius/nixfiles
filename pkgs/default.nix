self: super: rec {
  preview = super.callPackage ./preview { };
  g-neovim = super.callPackage ./g-neovim { };
}
