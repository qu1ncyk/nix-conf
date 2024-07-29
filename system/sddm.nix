{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (sddm-chili-theme.override {
      themeConfig = {
        background = "${../user/sway/background.png}";
      };
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    theme = "chili";
    wayland.enable = true;
  };
}
