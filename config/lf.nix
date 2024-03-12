{pkgs, ...}: {
  home.file.".config/lf/lfrc".source = ./lfrc;
  home.packages = with pkgs; [
    ctpv
    lf
  ];
}
