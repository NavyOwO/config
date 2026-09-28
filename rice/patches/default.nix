{ lib, self, ... }: {
  nixpkgs.overlays = lib.singleton (_: prev:
    let obscura = self.inputs.obscura.packages.${prev.stdenv.system}; in
    {

      gomuks-web = prev.gomuks-web.overrideAttrs {
        patches = [
          ./gomuks-sso.patch
        ];
      };

      inherit (obscura)
        molecule
        zfullfs
        ;

      inherit (obscura.nvidia.entries) nvtop;
    });
}
