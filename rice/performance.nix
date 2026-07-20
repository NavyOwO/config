{ pkgs, config, ... }: {
  aquaris.persist.dirs = {
    "/root/.cache/pandemonium" = { };
  };

  boot =
    let
      # pkgs' = pkgs;

      pkgs' = (import (builtins.fetchTarball {
        url = "https://github.com/nixos/nixpkgs/tarball/9e09bc1f90dd4980521ff922d10d712ceb8a5a86";
        sha256 = "sha256-Ewa/O6OlwvmoR9x53Emb3rAWlhM7MLZuw1jCYhaX6sU=";
      })) {
        inherit (pkgs) config;
        inherit (pkgs.stdenv) system;
      };
    in
    {
      kernelPackages = pkgs'.linuxPackages_zen;

      zfs = {
        package = pkgs'.zfs;
        forceImportRoot = true;
      };
    };

  programs = {
    gamemode.enable = true;
  };

  services = {
    scx = {
      enable = true;
      package = pkgs.scx.rustscheds;
      scheduler = "scx_pandemonium";
    };

    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
  };

  users.users = builtins.mapAttrs
    (_: _: { extraGroups = [ "gamemode" ]; })
    config.aquaris.users;
}
