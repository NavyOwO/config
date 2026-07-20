{ pkgs, lib, ... }: {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.iosevka
      noto-fonts
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "IosevkaNerdFont" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  home-manager.sharedModules = lib.singleton (hm: {
    gtk = rec {
      enable = true;
      colorScheme = "dark";

      theme = {
        name = "Gruvbox-Dark";
        package = pkgs.gruvbox-gtk-theme;
      };

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      gtk2.configLocation =
        "${hm.config.xdg.configHome}/gtk-2.0/settings.ini";

      gtk4 = { inherit theme; };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

    home = {
      pointerCursor = {
        name = "Vanilla-DMZ";
        size = 24;
        package = pkgs.vanilla-dmz;
        gtk.enable = true;
      };

      packages = with pkgs; [
        qt5.qtwayland
        qt6.qtwayland
      ];
    };
  });
}
