{ lib, config, pkgs, ... }:

let
  cfg = config.homeModules.desktop.wayland.launcher.tofi;
  fonts = config.homeModules.theme.fonts;
  inherit (config.colorscheme) colors;
in

{

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.tofi];
    xdg.configFile."tofi/config".text = /* config */ ''
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
      prompt-color = ${colors.base0B}
      input-color = ${colors.base05}
      placeholder-color = ${colors.base03}
      default-result-color = ${colors.base03}
      selection-color = ${colors.base04}
    '';
  };
  
}

