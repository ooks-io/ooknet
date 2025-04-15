{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.console) profile;
in {
  config = mkIf (profile == "minimal") {
    ooknet.console = {
      editor = "nvim";
      multiplexer = "zellij";
      tools = {
        git.enable = true;
        starship.enable = true;
        ssh.enable = true;
      };
    };
  };
}
