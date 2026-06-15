{
  lib,
  osConfig,
  self',
  ...
}: let
  inherit (lib) elem mkIf;
  inherit (builtins) attrValues;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  # fhs variant is upstreams recommended default (MCP servers)
  config = mkIf (elem "ai" profiles) {
    home.packages = attrValues {
      inherit (self'.packages) claude-desktop-fhs;
    };
  };
}
