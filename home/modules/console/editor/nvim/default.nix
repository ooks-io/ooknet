{ config, lib, inputs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.editor.nvim;
  console = config.ooknet.console;
in
  
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./settings.nix
    ./keymapping.nix
    ./plugins
    ./colorscheme.nix
  ];
  
  config = mkIf (cfg.enable || console.editor == "nvim") {
    programs.neovim = {
      viAlias = true;
      vimAlias = true;  
    };

    programs.nixvim = {
      enable = true;
      plugins = {
        which-key = {
          enable = true;
          keyLabels = {
            " " = "<space>";
          };
        };
      };  
    };
  };
}
