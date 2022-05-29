final: prev: {
  g-alacritty = prev.callPackage ./g-alacritty { };
  g-firefox = prev.callPackage ./g-firefox { };
  g-lf = prev.callPackage ./g-lf { };
  g-neovim = prev.callPackage ./g-neovim { };
  g-pistol = prev.callPackage ./g-pistol { };
  g-polybar = prev.callPackage ./g-polybar { };
  g-rofi = prev.callPackage ./g-rofi { };
  g-termite = prev.callPackage ./g-termite { };
  shell-config = prev.callPackage ./shell-config { };
  zsh-forgit = prev.callPackage ./zsh-forgit { };

  discord-for-poor-people = with prev; makeDesktopItem {
    name = "Discord";
    desktopName = "Discord new";
    genericName = "All-in-one cross-platform voice and text chat for gamers";
    exec = "${chromium}/bin/chromium --app=\"https://discord.com/channels/@me\"";
    icon = "discord";
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    terminal = false;
    mimeTypes = [ "x-scheme-handler/discord" ];
  };

  element-for-poor-people = with prev; makeDesktopItem {
    name = "Element";
    desktopName = "Element";
    genericName = "Secure and independent communication, connected via Matrix";
    exec = "${chromium}/bin/chromium --app=\"https://app.element.io/#/home\"";
    icon = "element";
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    terminal = false;
  };

  yuescript = prev.stdenv.mkDerivation {
    pname = "yuescript";
    version = "0.5.0-1";

    installPhase = ''
      cp -R bin/release/ $out

    '';

    src = prev.fetchFromGitHub {
      owner = "pigpigyyy";
      repo = "Yuescript";
      rev = "6d290f08181a543778c75748b66c513bb8e33423";
      sha256 = "sha256-LLIXNkoDxe43IqghA42q6c/o5SWuI/n7A6qy7XxMn30=";
    };

  };
}
