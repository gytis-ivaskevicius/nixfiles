{ pkgs, ... }: {


  programs.git = {
    enable = true;
    #delta.enable = true;
    lfs.enable = true;
    userEmail = "me@gytis.io";
    userName = "Gytis Ivaškevičius";
    signing.signByDefault = true;
    signing.key = "DFAF982C85779001E06E1B1D5680CA190BD2B15B";

    aliases = {
      graph = "log --graph --decorate --oneline";
      map = "!git graph --all";
      watch = "!watch -ct 'git -c color.status=always status -s && echo && git map --color'";
    };
  };
}
