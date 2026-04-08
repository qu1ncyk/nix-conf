{pkgs, ...}: {
  home.file.".icons/default".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";

  gtk = {
    enable = true;
    theme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze-Dark";
    };
    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "Breeze-Dark";
    };
    gtk4.theme = null;
  };
  qt = {
    enable = true;
    platformTheme = {
      package = pkgs.kdePackages.breeze;
      name = "Breeze-Dark";
    };
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    gtk.enable = true;
  };
}
