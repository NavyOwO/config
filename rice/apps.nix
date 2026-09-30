{ pkgs, lib, config, ... }: {
  aquaris.persist.dirs = {
    "/var/lib/flatpak" = { };
  };

  programs = { 
    steam.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
      # add other bs here if needed :)
    ];
  };

  };

  services.flatpak.enable = true;

  time.timeZone = "Europe/London";
  i18n.extraLocaleSettings.LC_TIME = "en_US.UTF-8";

  rice.unfreeNames = [
    "steam"
    "steam-unwrapped"
    "wootility"
    "lunarclient"
    "osu-lazer-bin"
  ];

  hardware = {
    logitech.wireless.enable = true;
    wooting.enable = true;
  };

  users.users = builtins.mapAttrs
    (_: _: { extraGroups = [ "adbusers" "wireshark" ]; })
    config.aquaris.users;

  home-manager.sharedModules = [{
    aquaris = {
      persist = {
        ".config/OpenRGB" = { };
        ".config/chromium" = { };
        ".config/equibop" = { };
        ".config/heroic" = { };
        ".config/lunarclient" = { };
        ".config/nicotine" = { };
        ".config/obs-studio" = { };
        ".config/openttd" = { };
        ".config/pulse" = { };
        ".config/wootility" = { };

        ".mixxx" = { };
        ".java" = { };
        ".lunarclient" = { };
        ".minecraft" = { };
        ".mozilla" = { };
        ".thunderbird" = { };
        ".var/app/org.vinegarhq.Sober" = { };
        ".steam" = { };
        ".wine" = { };

        ".local/share/Prismlauncher" = { };
        ".local/share/Steam" = { };
        ".local/share/chatterino" = { };
        ".local/share/openttd" = { };
        ".local/share/osu" = { };
        ".local/share/prismlauncher" = { };
        ".local/share/umu" = { };
        ".local/share/zathura" = { };

        ".local/state/syncthing" = { };

        "Exports" = { };
        "Games" = { };
        "KeptDownloads" = { };
        "OBS" = { };
        "VMstuff" = { };
        "CodeStuff" = { };
        "OSUstuff" = { };
      };

      firefox = {
        enable = true;

        prefs = {
          # can't connect to livekit calls when DTLS v1.3 (772) is enabled
          # https://bugzilla.mozilla.org/show_bug.cgi?id=2033783
          "media.peerconnection.dtls.version.max" = 771;
        };

        settings.ui.invert = true; # don't hide anything
      };
    };

    programs.libreoffice.enable = true;
    home.pointerCursor.enable = true;

    services = { 
      mpd-discord-rpc.enable = true;
      syncthing.enable = true;

      mako = {
        enable = true;

        settings = {
          font = "Iosevka NF";
          default-timeout = 70000;
          background-color = "#282828a0";
          text-color = "#eddbb2";
          border-radius = 5;
          border-color = "#ffffffc9";
          icon-location = "left";
          icon-border-radius = 999;
          output = "HDMI-A-1";
          layer = "overlay";
          anchor = "top-right";
          #on-notify = "exec mpv ${./notif.opus}";

          "app-name=flameshot" = {
            invisible = true;
          };
        };
      };

    };

    home.packages = with pkgs; [
      android-tools
      audacity
      chatterino7
      chromium
      equibop
      feh
      ffmpeg
      flameshot
      gimp
      grim
      heroic
      kdePackages.kdenlive
      krita
      libnotify
      lunar-client
      mixxx
      mpd-discord-rpc
      mpv
      nicotine-plus
      nixpkgs-fmt
      nmap
      nvtop
      openrgb
      openttd
      osu-lazer-bin
      prismlauncher
      pulsemixer
      qbittorrent
      rmpc
      solaar
      swaybg
      tageditor
      thunderbird
      timezonemap
      umu-launcher
      wine
      wl-clipboard
      yt-dlp
      zathura
    ];

    programs = {
      jujutsu.settings.signing.key = lib.mkForce "~/.ssh/id_main";

      obs-studio = {
        enable = true;

        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          obs-vkcapture
        ];
      };
    };

    xdg = {
      configFile."equibop-flags.conf".text = ''
        --wayland
      '';

      desktopEntries = {
        "com.obsproject.Studio" = {
          name = "OBS Studio";
          icon = "com.obsproject.Studio";
          exec = "env LD_LIBRARY_PATH=/run/opengl-driver/lib obs";
        };
      };
    };
  }];
}
