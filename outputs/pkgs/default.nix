{ook, ...}: {
  perSystem = {pkgs, ...}: let
    inherit (ook.lib) mkNeovim;
    ook-vim-config = import ./ook-vim;
    inherit (pkgs) callPackage;
  in {
    packages = {
      repopack = callPackage ./repopack {};
      live-buds-cli = callPackage ./live-buds-cli {};
      instawow-tsm = callPackage ./instawow/plugins/tsm.nix {};

      ook-vim = mkNeovim pkgs [ook-vim-config];
    };
  };
}
