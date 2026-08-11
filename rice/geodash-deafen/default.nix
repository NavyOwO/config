{ pkgs, ... }: {
  home-manager.sharedModules = [{
    home.packages = with pkgs; [
      python3
      (writers.writePython3Bin "geodash-deafen" { doCheck = false; }
        (builtins.readFile ./main.py))
    ];
  }];
}
