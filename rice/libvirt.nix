{ pkgs, config, ... }: {
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  users.users = builtins.mapAttrs
    (_: _: { extraGroups = [ "libvirtd" ]; })
    config.aquaris.users;

  home-manager.sharedModules = [{
    home.packages = with pkgs; [ virt-manager ];
  }];
}
