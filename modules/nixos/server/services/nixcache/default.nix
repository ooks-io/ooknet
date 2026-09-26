# binary cache serving this hosts /nix/store, tailnet only.
# push with `nix copy --to ssh-ng://<host> <path>`
{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
in {
  config = mkIf (elem "nixcache" services) {
    services.harmonia.cache = {
      enable = true;
      signKeyPaths = [config.age.secrets.nixcache-key.path];
      settings = {
        bind = "[::]:5000";
        # below cache.nixos.org (40) so upstream wins for anything it has
        priority = 50;
      };
    };

    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [5000];
  };
}
