{ pkgs, lib, ... }:
let
  inherit (lib) mkForce;
  no = mkForce false;
in
{
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "pcie_acs_override=downstream,multifunction"
  ];

  services.caddy = {
    enable = true;

    virtualHosts = {
      "https://192.168.122.1:8080".extraConfig = ''
        reverse_proxy localhost:37812
      '';
    };
  };

  specialisation.windows.configuration = {
    boot = {
      kernelParams = [
        "initcall_blacklist=sysfb_init"
      ];

      blacklistedKernelModules = [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
        "nvidia_uvm"
        "snd_hda_intel"
      ];

      extraModprobeConfig = ''
        options vfio-pci ids=10de:2882 disable_vga=1
        options snd-hda-core gpu_bind=0
        options kvm ignore_msrs=1
      '';
    };

    systemd = {
      services.start-windows = {
        wantedBy = [ "multi-user.target" ];

        after = [ "libvirtd.service" ];
        wants = [ "libvirtd.service" ];

        path = with pkgs; [ libvirt ];

        script = ''
          virsh -c qemu:///system start win11
        '';
      };

      user = {
        services = {
          pipewire.enable = no;
          pipewire-pulse.enable = no;
          wireplumber.enable = no;
        };

        sockets = {
          pipewire.enable = no;
          pipewire-pulse.enable = no;
        };
      };
    };

    services = {
      greetd.enable = no;
      mullvad-vpn.enable = no;
    };


    virtualisation = {
      waydroid.enable = no;

      libvirtd.hooks.qemu.windows = pkgs.writeShellScript "windows" ''
        if [ "$1" = "win11" ] && [ "$2" = "release" ]; then
          ${pkgs.systemd}/bin/systemctl reboot
        fi
      '';
    };

    home-manager.sharedModules = [{
      services = {
        mpd.enable = no;
        mpd-discord-rpc.enable = no;
        syncthing.enable = no;
      };
    }];
  };
}

