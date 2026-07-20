{ lib, self, ... }: {
  nixpkgs.overlays = lib.singleton (_: prev:
    let obscura = self.inputs.obscura.packages.${prev.stdenv.system}; in
    {
      nix-output-monitor = obscura.my-nom;

      inherit (obscura.nvidia.entries) nvtop;
    });
}
