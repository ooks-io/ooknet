{ lib, config, osConfig, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.tools.ssh;
in

{
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      compression = true;
      hashKnownHosts = true;
      matchBlocks = {
        "github.com" = {
          user = "git";
          hostname = "github.com";
          identityFile = "${osConfig.age.secrets.github_key.path}";
        };
      };
    };
  };
}
