{
  osConfig,
  lib,
  ...
}: let
  inherit (osConfig.ooknet.appearance) colorscheme fonts;
  inherit (colorscheme) palette;
  inherit (osConfig.ooknet.workstation) environment;
  inherit (lib) mkIf;
in {
  config = mkIf (environment == "hyprland") {
    services.mako = {
      enable = true;
      font = "${fonts.regular.family} 12";
      padding = "10,10";
      anchor = "top-right";
      width = 300;
      height = 100;
      borderSize = 2;
      defaultTimeout = 3000;
      backgroundColor = "#${palette.base00}dd";
      borderColor = "#${palette.base05}dd";
      textColor = "#${palette.base05}dd";
      extraConfig = ''
        [app-name="system-notify"]
        padding=3,3
        width=100
        height=100
        [urgency=critical]
        padding=3,3
        width=100
        height=100
        anchor=top-center
        border-color=#${palette.base08}dd
      '';
    };
  };
}
