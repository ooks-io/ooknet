{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) nullOr listOf enum bool;
in {
  options.ooknet.server = {
    exitNode = mkOption {
      type = bool;
      default = false;
      description = "Whether the server will act as a tailscale exit node or not";
    };
    profile = mkOption {
      type = nullOr (enum ["linode"]);
      default = null;
      description = "The server profile the host will use as a base";
    };
    services = mkOption {
      type = listOf (enum ["website"]);
      default = [];
      description = "List of services the server will host";
    };
  };
}
