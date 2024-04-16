{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (sddm-chili-theme.override {
      themeConfig = {
        background = toString ../user/sway/background.png;
      };
    })
  ];

  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "chili";
      wayland.enable = true;
    };
  };
}
