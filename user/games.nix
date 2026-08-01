{
  pkgs,
  stable-pkgs,
  ...
}: let
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
    archipelago
    heroic
    stable-pkgs.mindustry
    olympus
    parsec-bin
    prismlauncher
    r2modman
    retroarch
  ];
}
