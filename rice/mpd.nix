{ pkgs, lib, ... }: {
  home-manager.sharedModules = lib.singleton (hm: {
    aquaris.persist = {
      ".local/share/mpd" = { };
    };

    home.packages = with pkgs; [
      ffmpeg # conversions, ffprobe, ...
      kid3-cli # setting tags manually
      moreutils # vidir the GOAT
    ];

    services.mpd = {
      enable = true;
      musicDirectory = "${hm.config.home.homeDirectory}/disks/beeg/Music";
      extraConfig = ''
        audio_output {
          type "pulse"
          name "pulse"
        }

        audio_output {
          type "fifo"
          name "fifo"
          path "/tmp/mpd.fifo"
        }
      '';
    };

    programs.ncmpcpp = {
      enable = true;
      settings = {
        lyrics_directory = "~/.local/share/lyrics";
        media_library_albums_split_by_date = "no";
        media_library_primary_tag = "album_artist";
        startup_screen = "media_library";

        main_window_color = "blue";
      };
    };
  });
}
