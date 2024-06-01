{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (sddm-chili-theme.override {
      themeConfig = {
        background = toString ../user/sway/background.png;
      };
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    theme = "chili";
    wayland.enable = true;
  };
}
