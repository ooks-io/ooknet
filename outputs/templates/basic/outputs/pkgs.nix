{self, ...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.default = pkgs.stdenvNoCC.mkDerivation {
      pname = "my package";
      version = "0.1.0";
      src = "${self}/src";
      nativeBuildInputs = [];

      buildPhase = "";
      dontInstall = true;
    };
    apps.default = self'.packages.default;
  };
}
