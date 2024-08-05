{
  inputs,
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (osConfig.ooknet.appearance) colorscheme;
  inherit (config.ooknet) console;
  inherit (lib) mkIf;
  cfg = config.ooknet.editor.helix;
in {
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
              nodePackages.vscode-langservers-extracted
              shellcheck
            ])
          ];
      });
      settings = {
        theme = "base16_transparent";
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
            left = ["mode" "spinner"];
            center = ["file-name"];
            right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
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
    };
  };
}
