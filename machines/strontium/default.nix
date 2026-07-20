{ aquaris, lib, ... }: {
  imports = [ ../../rice ];

  aquaris = {
    users = lib.mkMerge [
      { inherit (aquaris.cfg.users) logan; }
      { logan.admin = true; }
    ];

    machine = {
      id = "6c832ae810ee90b2217ff1c16a24519a";
      secureboot = false;
    };

    secrets.pub = "fjD7qCYH0-KGgXxTzYyct3OBOt1S1J57ZFrIOxRRsHc";

    persist.enable = true;

    filesystems = { fs, ... }: {
      zpools.rpool = fs.defaultPool;

      disks = {
        # Samsung SSD 850 "sdb" - boot drive
        "/dev/disk/by-id/wwn-0x5002538da0095714".partitions = [
          fs.defaultBoot
          { content = fs.zpool (p: p.rpool); }
        ];

        # ST1000LM048-2E71 "sda"
        "/dev/disk/by-id/wwn-0x5000c500bf0b5254".partitions = [
          { content = fs.zpool (p: p.rpool); }
        ];

        # ST3500312CS "sdc"
        "/dev/disk/by-id/wwn-0x5000c50079b3af1a".partitions = [
          { content = fs.zpool (p: p.rpool); }
        ];
      };
    };
  };
}
