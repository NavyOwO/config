{ pkgs, lib, ... }: {
  services = {
    desktopManager.plasma6.enable = true;
    power-profiles-daemon.enable = lib.mkForce false;
    speechd.enable = lib.mkForce false;
  };

  networking.modemmanager.enable = lib.mkForce false;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover
    elisa
    kmail
    konsole
    plasma-browser-integration
  ];
}
