{ inputs, config, pkgs, lib, ... }:
let
  cfg = config.homeModules.console.editor.helix;
  inherit (config) colorscheme;
in
{

  imports = [
    ./languages.nix
  ];
  
  config = {
    programs.helix = lib.mkIf cfg.enable {
      enable = true;
      defaultEditor = lib.mkIf cfg.default true;
      package = 
        inputs.helix.packages.${pkgs.system}.default.overrideAttrs (self: {
              makeWrapperArgs = with pkgs;
                self.makeWrapperArgs
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
