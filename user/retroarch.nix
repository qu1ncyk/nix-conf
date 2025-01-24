{pkgs, ...}: let
  doukutsu = pkgs.callPackage ../pkgs/doukutsu-rs-libretro.nix {};
in {
  home.packages = [
    (pkgs.retroarch-bare.wrapper {
      cores = with pkgs.libretro; [
        bsnes
        doukutsu
        mgba
        nestopia
      ];
    })
  ];
}
