{
  services.mullvad-vpn.enable = true;

  systemd.services.mullvad-daemon.environment = {
    MULLVAD_SETTINGS_DIR = "/var/lib/mullvad-vpn";
  };

  aquaris.persist.dirs = {
    "/var/lib/mullvad-vpn" = { };
  };
}
