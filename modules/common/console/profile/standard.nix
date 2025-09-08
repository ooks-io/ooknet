{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.console) profile;
in {
  config = mkIf (profile == "standard") {
    ooknet.console = {
      editor = "nvim";
      multiplexer = "zellij";
      tools = {
        codex.enable = true;
        bat.enable = true;
        btop.enable = true;
        direnv.enable = true;
        eza.enable = true;
        ffmpeg.enable = true;
        fzf.enable = true;
        git.enable = true;
        nixIndex.enable = true;
        starship.enable = true;
        utils.enable = true;
        ssh.enable = true;
      };
    };
  };
}
