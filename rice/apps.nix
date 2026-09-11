{ pkgs, lib, config, ... }: {
  aquaris.persist.dirs = {
    "/var/lib/flatpak" = { };
  };

  programs.steam.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
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
        ".local/share/prismlauncher" = { };
        ".local/share/umu" = { };
        ".local/share/osu" = { };

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

    home.pointerCursor.enable = true;
    services.mpd-discord-rpc.enable = true;

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

      #fuck you microsoft
      dotnet-sdk_11
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
