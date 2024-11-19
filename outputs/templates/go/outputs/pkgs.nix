{self, ...}: {
  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.default = pkgs.buildGoModule {
      pname = "hello";
      version = "0.0.1";
      src = "${self}/src";
      meta.mainProgram = "hello";
      vendorHash = null;
    };
    apps.default = {
      type = "app";
      program = "${lib.getExe self'.packages.default}";
    };
  };
}
