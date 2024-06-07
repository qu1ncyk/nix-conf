{pkgs, ...}: {
  home.packages = [
    (pkgs.retroarch.override {
      cores = with pkgs.libretro; [
        bsnes
        mgba
        nestopia
      ];
    })
  ];
}
