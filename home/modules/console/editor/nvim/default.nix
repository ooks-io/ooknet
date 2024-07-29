{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet) console;

  cfg = config.ooknet.editor.nvim;

  ookvim = inputs.ooks-vim.packages.${pkgs.system}.ooks-vim;
in {
  config = mkIf (cfg.enable || console.editor == "nvim") {
    home.packages = [ookvim];
    home.sessionVariables.EDITOR = mkIf (console.editor == "nvim") "nvim";
  };
}
