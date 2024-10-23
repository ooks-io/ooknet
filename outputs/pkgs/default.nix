{ook, ...}: {
  perSystem = {pkgs, ...}: let
    inherit (ook.lib) mkNeovim;
    ook-vim-config = import ./ook-vim;
  in {
    packages = {
      repopack = pkgs.callPackage ./repopack {};
      live-buds-cli = pkgs.callPackage ./live-buds-cli {};
      ook-vim = mkNeovim pkgs [ook-vim-config];
    };
  };
}
