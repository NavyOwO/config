{ pkgs, ... }: {

  programs.steam.enable = true;

  rice.unfreeNames = [
    "steam"
    "steam-unwrapped"
  ];

  environment.systemPackages = with pkgs; [
    swaybg
    flameshot
    grim
  ];

  programs.waybar.enable = true;

  home-manager.sharedModules = [{
    aquaris = {
      persist = {
        ".config/equibop" = { };
        ".local/share/Steam" = { };
        ".local/share/chatterino" = { };
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

    home.packages = with pkgs; [
      chatterino7
      equibop
      mpv
      nixpkgs-fmt
      nvtop
      pulsemixer
      qalculate-gtk
      yt-dlp
    ];

    programs = {
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
