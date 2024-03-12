{ pkgs, ... }:

{
  home.file.".config/nvim".source = ./.;
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    gcc
    marksman
    nil
    nodePackages.prettier
    nodePackages.pyright
    nodePackages.typescript-language-server
    python311Packages.autopep8
    python311Packages.flake8
  ];
}
