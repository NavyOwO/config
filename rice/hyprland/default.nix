{ pkgs, lib, ... }: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.speechd.enable = lib.mkForce false;

  home-manager.sharedModules = lib.singleton {
    aquaris = {
      persist = {
        ".config/dconf" = { };
      };

      hyprland = {
        enable = true;

        precfg = builtins.readFile ./lib.lua;

        env = {
          "HYPRCURSOR_SIZE" = "24";
          "XCURSOR_SIZE" = "24";

          "GDK_BACKEND" = "wayland";
          "QT_QPA_PLATFORM" = "wayland";
          "SDL_VIDEODRIVER" = "wayland";

          "NIXOS_OZONE_WL" = "1";
          "_JAVA_AWT_WM_NONREPARENTING" = "1";
        };

        events = f: with f; {
          "hyprland.start" = [
            (exec "swaybg -o HDMI-A-1 -i ~/config/wallpaper.png")
            (exec "swaybg -o DP-2 -i ~/config/wallpaper2.png")
            (exec "equibop")
            (exec "steam")

            # TODO actually fix this at some point
            (exec "xdg-settings set default-web-browser librewolf.desktop")
          ];
        };

        settings = {
          monitor = [
            { output = "HDMI-A-1"; mode = "1920x1080@240"; position = "0x0"; scale = 1; }
            { output = "DP-2"; mode = "1920x1080@60"; position = "-1080x-350"; scale = 1; transform = 1; }
          ];

          config = {
            general = {
              border_size = 1;
              gaps_in = 0;
              gaps_out = 1;

              col = {
                active_border = "rgba(ddddddff)";
                inactive_border = "rgba(82828200)";
              };

              layout = "dwindle";
            };

            decoration = {
              border_part_of_window = false;
              rounding = 6;
              rounding_power = 2;

              blur = {
                enabled = true;
                size = 4;
                passes = 2;
                brightness = 0.7;
                vibrancy = 0.0;
              };
            };

            dwindle = {
              force_split = 2;
              preserve_split = true;
            };

            ecosystem = {
              no_update_news = true;
              no_donation_nag = true;
            };

            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;

              enable_swallow = true;
              swallow_regex = "foot";

              on_focus_under_fullscreen = 2;
            };

            input = {
              kb_layout = "gb";
              kb_options = "compose:sclk";
              repeat_rate = 50;
              repeat_delay = 300;
              sensitivity = -0.8;
            };

            cursor = {
              inactive_timeout = 1;
              persistent_warps = true;

              zoom_rigid = true;
              zoom_detached_camera = true;
            };
          };
        };

        binds = f: with f; {
          Print = raw (execR "flameshot" {
            decorate = false;
            dim_around = false;
            floating = true;
            stay_focused = true;
          });

          C-S-d = exec "equibop --toggle-deafen";
          F8 = raw (dsp ''pass({ window = "class:com.obsproject.Studio" })'');
          Return = exec "foot";
          a = exec "foot pulsemixer";
          i = exec "foot htop";
          l = exec "librewolf";
          m = exec "foot rmpc";
          x = exec "fuzzel";

          C-q = dsp ''window.kill()'';
          q = dsp ''window.close()'';
          v = dsp ''window.float({ "toggle" })'';

          f = fullscreen { internal = 1; }; # almost fullscreen, keep bar
          C-f = fullscreen { internal = 2; }; # true fullscreen
          A-f = fullscreen { client = 2; }; # fake fullscreen

          "mouse:272" = dsp "window.drag()";
          "mouse:273" = dsp "window.resize()";
        };

        animations = boobs: with boobs; {
          global = { speed = 10; curve = bezier "default"; };
          border = { speed = 5.39; curve = bezier "easeOutQuint"; };
          windows = { speed = 1.0; curve = bezier "linear"; style = "gnomed"; };
          windowsIn = { speed = 1.0; curve = bezier "linear"; style = "gnomed"; };
          windowsOut = { speed = 1.0; curve = bezier "linear"; style = "gnomed"; };
          fadeIn = { speed = 1.73; curve = bezier "easeOutQuint"; };
          fadeOut = { speed = 1.46; curve = bezier "easeOutQuint"; };
          layers = { speed = 3.81; curve = bezier "linear"; };
          layersIn = { speed = 4; curve = bezier "linear"; style = "fade"; };
          layersOut = { speed = 1.5; curve = bezier "linear"; style = "fade"; };
          fadeLayersIn = { speed = 1.79; curve = bezier "almostLinear"; };
          fadeLayersOut = { speed = 1.39; curve = bezier "almostLinear"; };
          workspaces = { speed = 1.94; curve = bezier "almostLinear"; };
          workspacesIn = { speed = 1.21; curve = bezier "almostLinear"; };
          workspacesOut = { speed = 1.94; curve = bezier "almostLinear"; };
        };

        curves = f: with f; {
          easeOutQuint = bezier {
            points = [
              [ 0.23 1.00 ]
              [ 0.32 1.00 ]
            ];
          };

          easeInOutCubic = bezier {
            points = [
              [ 0.65 0.05 ]
              [ 0.36 1.00 ]
            ];
          };

          linear = bezier {
            points = [
              [ 0.00 0.00 ]
              [ 1.00 1.00 ]
            ];
          };

          almostLinear = bezier {
            points = [
              [ 0.50 0.50 ]
              [ 0.75 1.00 ]
            ];
          };

          quick = bezier {
            points = [
              [ 0.15 0.00 ]
              [ 0.10 1.00 ]
            ];
          };

          easy = spring {
            mass = 1;
            stiffness = 71.2633;
            dampening = 15.8273644;
          };
        };
      };
    };

    xdg = {
      portal.extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];

      systemDirs.data = with pkgs; map glib.getSchemaDataDirPath [
        gsettings-desktop-schemas
        gtk3
      ];
    };

    programs = {
      foot = {
        enable = true;

        settings = {
          main = {
            font = "monospace:size=10.5";
            include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";
          };

          colors-dark = {
            alpha = "0.5";
            blur = true;
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
  };
}
