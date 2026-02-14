{
  pkgs,
  stable-pkgs,
  lazy-too,
  ...
}: {
  home.packages = [(import ./. {inherit pkgs stable-pkgs lazy-too;}).neovim];
}
