{ pkgs, ... }: {
  aquaris.persist.dirs = {
    "/var/lib/private/gomuks-web" = { };
  };

  systemd.services.gomuks-web = {
    path = with pkgs; [ gomuks-web ];
    script = ''
      export GOMUKS_ROOT="$STATE_DIRECTORY"
      exec gomuks-web << EOF
      admin
      admin
      EOF
    '';

    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      StateDirectory = "gomuks-web";
    };

    wantedBy = [ "default.target" ];
  };

  home-manager.sharedModules = [{
    systemd.user.services.molecule = {
      Install.WantedBy = [ "default.target" ];

      Unit = {
        After = [ "pipewire.service" ];
        BindsTo = [ "pipewire.service" ];
      };

      Service.ExecStart = pkgs.lib.getExe pkgs.molecule;
    };
  }];
}
