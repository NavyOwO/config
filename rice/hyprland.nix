{ pkgs, lib, config, ... }: {
  programs.hyprland.enable = true;
  services.speechd.enable = false;

  home-manager.sharedModules = lib.singleton (hm: {
    aquaris.persist = {
      ".config/dconf" = { };
    };

    xdg = {
      portal.extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];

      systemDirs.data = with pkgs; map glib.getSchemaDataDirPath [
        gsettings-desktop-schemas
        gtk3
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
      extraConfig = builtins.readFile ./hyprland.conf;
    };

    home.packages = with pkgs; [ fuzzel ];

    programs = {
      foot = {
        enable = true;

        settings = {
          main = {
            font = "monospace:size=10.5";
            include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";
          };
        };
      };

      fuzzel = {
        enable = true;

        settings = {
          main = {
            terminal = "foot";
            font = "monospace:size=14";
          };

          colors = {
            background = "282828e6";
            input = "ebdbb2ff";
            prompt = "ebdbb2ff";
            selection = "000000ff";
            selection-text = "ebdbb2ff";
            text = "ebdbb2ff";
          };
        };
      };
    };
  });
}
