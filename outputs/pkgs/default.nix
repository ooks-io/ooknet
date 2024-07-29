{
  perSystem = {pkgs, ...}: {
    packages = {
      live-buds-cli = pkgs.callPackage ./live-buds-cli {};
    };
  };
}
