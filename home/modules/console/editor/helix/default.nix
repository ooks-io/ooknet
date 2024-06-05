{ inputs, config, pkgs, lib, ... }:

let
  inherit (config) colorscheme;
  inherit (lib) mkIf;
  cfg = config.ooknet.editor.helix;
  console = config.ooknet.console;
in

{
  imports = [
    ./languages.nix
  ];
  
  config = mkIf (cfg.enable || console.editor == "helix") {
    programs.helix = {
      enable = true;
      defaultEditor = mkIf (console.editor == "helix") true;
      package = inputs.helix.packages.${pkgs.system}.default.overrideAttrs (old: {
        makeWrapperArgs = with pkgs;
          old.makeWrapperArgs
          or []
          ++ [
            "--suffix"
            "PATH"
            ":"
            (lib.makeBinPath [
              clang-tools
              marksman
              nil
              nodePackages.bash-language-server
              nodePackages.vscode-css-languageserver-bin
              nodePackages.vscode-langservers-extracted
              shellcheck
            ])
          ];
      });
      settings = {
        theme = colorscheme.slug;
        editor = {
          color-modes = true;
          middle-click-paste = false;
          line-number = "relative";
          indent-guides.render = true;
          true-color = true;
          cursorline = true;
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          statusline = {
            left = [ "mode" "spinner" ];
            center = [ "file-name" ];
            right = [ "diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
        };
        keys.normal.space.u = {
          f = ":format";
          w = ":set whitespace.render all";
          W = ":set whitespace.render none";
        };
      };
      themes = import ./theme.nix { inherit colorscheme; };
    };
  };
}
