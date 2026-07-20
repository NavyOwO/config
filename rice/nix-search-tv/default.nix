{ pkgs, ... }: {
  home-manager.sharedModules = [{
    aquaris.persist = {
      ".cache/nix-search-tv" = { };
    };

    home.packages = [
      (pkgs.writeShellApplication {
        name = "ntv";

        runtimeInputs = with pkgs; [
          fzf
          nix-search-tv
        ];

        text = builtins.readFile ./main.sh;
      })
    ];
  }];
}
