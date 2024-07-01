{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.editor.nvim;
  console = config.ooknet.console;
in

{
  config = mkIf (cfg.enable || console.editor == "nvim") {
    programs.nixvim.plugins = {
      lsp-lines.enable = true;
      lsp = {
        enable = true;
        capabilities = "offsetEncoding = 'utf-16'";
        servers = {

          # nix
          nil-ls = {
            enable = true;
          };
          # markdown
          marksman = {
            enable = true;
          };
          # css
          cssls = {
            enable = true;
          };
          # c/c++
          clangd = {
            enable = true;
          };
        };
      };
    };
  };
}
