{ pkgs, config, ... }: {
  aquaris.persist.dirs = {
    "/root/.cache/pandemonium" = { };
  };

  boot =
    let
      pkgs' = pkgs;

      # pkgs' = (import (builtins.fetchTarball {
      #   url = "https://github.com/nixos/nixpkgs/tarball/";
      #   sha256 = "";
      # })) {
      #   inherit (pkgs) config;
      #   inherit (pkgs.stdenv) system;
      # };
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
