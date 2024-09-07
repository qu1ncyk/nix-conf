{stable-pkgs, ...}: {
  home.packages = [
    (stable-pkgs.retroarch.override {
      cores = with stable-pkgs.libretro; [
        bsnes
        mgba
        nestopia
      ];
    })
  ];
}
