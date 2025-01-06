{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage;
  in {
    packages = {
      repopack = callPackage ./repopack {};
      live-buds-cli = callPackage ./live-buds-cli {};
      website = callPackage ./website {};
      caddy-with-cloudflare = callPackage ./caddy-with-cloudflare {};

      #ook-vim = mkNeovim pkgs [ook-vim-config];
      ook-vim = callPackage ./ook-vim {inherit inputs pkgs lib;};
    };
  };
}
