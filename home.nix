{pkgs, ...}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "quincy";
  home.homeDirectory = "/home/quincy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [
    user/git.nix
    user/kitty.nix
    user/lf.nix
    user/lazy-too/hm-module.nix
    user/games.nix
    user/sway
    user/systemd
    user/waybar
    user/zathura.nix
    user/zk.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bluetuith
    (discord.overrideAttrs {
      postFixup = ''
        wrapProgram $out/bin/discord --set XDG_SESSION_TYPE x11
        wrapProgram $out/bin/Discord --set XDG_SESSION_TYPE x11
      '';
    })
    dunst
    file
    gimp
    keepassxc
    libreoffice
    networkmanagerapplet
    p7zip
    pavucontrol
    playerctl
    restic
    ripgrep
    safeeyes
    syncthing
    thunderbird
    unzip
    wget
    wl-clipboard
    wl-clipboard-x11
    wl-mirror
    vlc
    xdg-utils
    zip

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    nerd-fonts.ubuntu-mono
    ubuntu_font_family

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file.".icons/default".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/quincy/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";
  programs = {
    alacritty = {
      enable = true;
      settings.font = {
        size = 16;
        normal.family = "UbuntuMono Nerd Font";
      };
    };
    bashmount.enable = true;
    btop.enable = true;
    firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
    };
    imv.enable = true;
    wofi.enable = true;
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };
  };
  home.file.".XCompose".source = user/XCompose;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
