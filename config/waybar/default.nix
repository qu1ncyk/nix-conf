{ pkgs, ... }:

let
  css = pkgs.callPackage ./css.nix {};
in
{
  home.file.".config/waybar/config".source = ./config;
  home.file.".config/waybar/style.css".source = "${css}/style.css";
  programs.waybar.enable = true;
}
