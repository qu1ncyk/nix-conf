{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Quincy";
        email = "67159014+qu1ncyk@users.noreply.github.com";
      };
      signing = {
        backend = "gpg";
        behavior = "own";
        key = "75BF0BAAD56015FC";
      };
      ui = {
        default-command = "log";
      };
    };
  };
}
