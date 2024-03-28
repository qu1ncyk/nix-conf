{pkgs, ...}: {
  home.file.".config/sway".source = ./.;
  home.packages = with pkgs; [
    wl-gammarelay-rs
    sunwait
    sway
    swaybg
    sway-contrib.grimshot
  ];
  wayland.windowManager.sway.enable = true;
}
