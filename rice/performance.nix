{ pkgs, config, self, ... }:
let
  mvs = import self.inputs.obscura.inputs.multiverse {
    inherit (pkgs.stdenv) system;
    inherit (pkgs) config;
  };

  pkgs' = mvs.at (mvs.revOf "linux_7_2" "7.2.15");
in
{
  aquaris.persist.dirs = {
    "/root/.cache/pandemonium" = { };
  };

  boot = {
    kernelPackages = pkgs'.linuxPackages_7_2;

    zfs = {
      package = pkgs'.zfs;
      forceImportRoot = true;
    };
  };

  programs = {
    gamemode.enable = true;
  };

  services = {
    auto-cpufreq = {
      enable = true;
    };

    thermald = {
      enable = true;
      debug = true;
    };

    scx-loader = {
      enable = true;
      config.default_sched = "scx_pandemonium";
    };

    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
  };

  # https://github.com/ValveSoftware/steam-for-linux/issues/11392#issuecomment-5016893671
  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE_SIZE = 10737418240;
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
  };

  users.users = builtins.mapAttrs
    (_: _: { extraGroups = [ "gamemode" ]; })
    config.aquaris.users;

  home-manager.sharedModules = [{
    aquaris.persist = {
      ".cache/nvidia" = { };
    };
  }];
}
