{pkgs, lib, config, ... }: {

  programs.steam.enable = true;

  services.flatpak.enable = true;

  time.timeZone = "Europe/London";

  rice.unfreeNames = [
    "steam"
    "steam-unwrapped"
    "wootility"
  ];

  hardware.wooting.enable = true;



  users.users = builtins.mapAttrs
    (_: _: { extraGroups = [ "adbusers" ]; })
    config.aquaris.users;

  home-manager.sharedModules = [{
    aquaris = {
      persist = {
        ".config/equibop" = { };
        ".config/obs-studio" = { };
        ".config/wootility" = { };
        ".local/share/Steam" = { };
        ".local/share/chatterino" = { };
        ".config/nicotine" = { };
        ".config/pulse" = { };
        ".config/chromium" = { };
        ".config/OpenRGB" = { };
        ".mozilla" = { };
        ".thunderbird" = { };
        ".config/heroic" = { };
        ".var/app/org.vinegarhq.Sober" = { };
        "/var/lib/flatpak/app/org.vinegarhq.Sober" = { };
        "Games" = { };
        ".local/share/umu" = { };
        "OBS" = { };
        "VMstuff" = { };
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
      ani-cli
      chatterino7
      chromium
      ente-auth
      equibop
      feh
      ffmpeg
      flameshot
      gimp
      grim
      heroic
      kdePackages.kdenlive
      krita
      mpv
      mpd-discord-rpc
      nicotine-plus
      nixpkgs-fmt
      nvtop
      openrgb
      pulsemixer
      qbittorrent
      swaybg
      thunderbird
      timezonemap
      wine
      wl-clipboard
      yt-dlp
      libvirt
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
