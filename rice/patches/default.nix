{ lib, self, ... }: {
  nixpkgs.overlays = lib.singleton (_: prev:
    let obscura = self.inputs.obscura.packages.${prev.stdenv.system}; in
    {
      inherit (obscura)
        zfullfs
        ;

      inherit (obscura.nvidia.entries) nvtop;
    });
}
