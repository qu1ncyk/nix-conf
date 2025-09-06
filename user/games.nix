{pkgs, ...}: let
  doukutsu = pkgs.callPackage ../pkgs/doukutsu-rs-libretro.nix {};
  retroarch = pkgs.retroarch-bare.wrapper {
    cores = with pkgs.libretro; [
      bsnes
      doukutsu
      mgba
      nestopia
    ];
  };
in {
  home.packages = with pkgs; [
    mindustry
    olympus
    parsec-bin
    prismlauncher
    retroarch
  ];
}
