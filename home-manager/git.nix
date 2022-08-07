{ pkgs, ... }: {


  programs.git = {
    enable = true;
    difftastic.enable = true;
    lfs.enable = true;
    userEmail = "me@gytis.io";
    userName = "Gytis Ivaškevičius";
    #signing.signByDefault = true;
  };
}
