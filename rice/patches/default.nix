{ lib, self, ... }: {
  nixpkgs.overlays = lib.singleton (_: prev:
    let obscura = self.inputs.obscura.packages.${prev.stdenv.system}; in
    self.inputs.obscura.lib.infuse prev ({
      gomuks-web.__assign = obscura.my-gomuks-web;

      lixPackageSets.latest.__assign = prev.lixPackageSets.lix_2_96;
      lix.__assign = prev.lixPackageSets.lix_2_96.lix;
    } // lib.mapAttrs (_: x: { __assign = x; }) {
      inherit (obscura)
        molecule
        zfullfs
        ;

      inherit (obscura.nvidia.entries) nvtop;
    })
  );
}
