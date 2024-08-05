{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: let
  inherit (osConfig.ooknet.appearance) colorscheme fonts;
  inherit (colorscheme) palette;
  inherit (config.ooknet) wayland;
  inherit (lib) mkIf;
in {
  config = mkIf (wayland.launcher == "tofi") {
    home.packages = [pkgs.tofi];
    xdg.configFile."tofi/config".text =
      /*
      config
      */
      ''
        history = false
        clip-to-padding = false
        horizontal = true
        width = 40%
        height = 35
        anchor = top-left
        margin-top = 5
        margin-left = 25%
        num-results = 1
        border-width = 0
        outline-width = 0
        result-spacing = 10
        selection-background-padding = 30
        prompt-padding = 10
        font = "${fonts.monospace.family}"
        font-size = 14
        prompt-text = "  "
        background-color = #0000
        prompt-background = #0000
        prompt-color = ${palette.base0B}
        input-color = ${palette.base05}
        placeholder-color = ${palette.base03}
        default-result-color = ${palette.base03}
        selection-color = ${palette.base04}
      '';
  };
}
