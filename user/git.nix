{
  programs.git.enable = true;
  home.file.".gitconfig".source = ./gitconfig;
  # To silence a migration warning from 25.05
  programs.git.signing.format = null;
}
