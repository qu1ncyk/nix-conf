{pkgs, ...}: {
  home.file.".config/sway".source = ./.;
  home.packages = with pkgs; [
    wl-gammarelay-rs
    sunwait
    swaybg
    sway-contrib.grimshot
  ];
}
