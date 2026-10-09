{ pkgs, ... }: {

  programs.git = {
    enable = true;
    #delta.enable = true;
    lfs.enable = true;
    signing.signByDefault = true;
    signing.key = "DFAF982C85779001E06E1B1D5680CA190BD2B15B";

    settings = {
      user = {
        name = "Gytis Ivaškevičius";
        email = "me@gytis.io";
      };
      alias = {
        graph = "log --graph --decorate --oneline";
        map = "!git graph --all";
        watch = "!watch -ct 'git -c color.status=always status -s && echo && git map --color'";
        review = "log --format=\"%C(yellow)%h%Creset %Cblue%ar%Creset %ae %Cgreen%s%Creset%n%n%b\"";
      };
      # Rewrite GitHub SSH remotes to HTTPS so the gh credential helper
      # (configured in cli.nix) is used instead of the SSH key.
      url."https://github.com/".insteadOf = [
        "git@github.com:"
        "ssh://git@github.com/"
      ];
    };
  };
}
