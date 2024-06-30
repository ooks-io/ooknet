{ osConfig, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  profiles = osConfig.ooknet.host.profiles;
in

{
  config = mkIf (elem "console-tools" profiles) {
    ooknet.tools = {
      btop.enable = true;
      eza.enable = true;
      bat.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      git.enable = true;
      ssh.enable = true;
      nixIndex.enable = true;
      starship.enable = true;
      utils.enable = true;
      ffmpeg.enable = true;
      sourcegraph.enable = true;
    };
    ooknet.editor.nvim.enable = true;
  };
}
