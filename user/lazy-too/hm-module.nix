{
  pkgs,
  lazy-too,
  ...
}: {
  home.packages = [(import ./. {inherit pkgs lazy-too;}).neovim];
}
