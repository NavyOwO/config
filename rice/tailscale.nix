{ lib, config, ... }: {
  services = {
    tailscale.enable = true;
    openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  };

  users.users.root.openssh.authorizedKeys = {
    inherit (config.users.users.logan.openssh.authorizedKeys) keys;
  };
}
