{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) str nullOr listOf enum bool;
in {
  options.ooknet.server = {
    exitNode = mkOption {
      type = bool;
      default = false;
      description = "Whether the server will act as a tailscale exit node or not";
    };
    profile = mkOption {
      type = nullOr (enum ["linode" "ookstest"]);
      default = null;
      description = "The server profile the host will use as a base";
    };
    services = mkOption {
      type = listOf (enum ["media-server" "website" "forgejo" "ookflix" "minecraft" "minecraft-proxy" "copyparty" "monitoring" "authelia"]);
      default = [];
      description = "List of services the server will host";
    };
    domain = mkOption {
      type = str;
      default = "";
    };

    webserver = {
      caddy = {
        enable = mkEnableOption "";
        cloudflare.enable = mkEnableOption "";
      };
    };
    database = {
      postgresql.enable = mkEnableOption "";
    };
  };
}
