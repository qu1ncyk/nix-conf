{pkgs, ...}: {
  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds.bg = "${../user/sway}/background.png";
    settings = {
      LoginScreen.background = "background.png";
      LockScreen.background = "background.png";
    };
  };

  environment.systemPackages = [pkgs.adwaita-icon-theme];

  services.displayManager.sddm = {
    settings = {
      Theme.CursorTheme = "Adwaita";
      Theme.CursorSize = 24;
    };
    # Cursor is broken on weston
    wayland.compositor = "kwin";
  };
}
