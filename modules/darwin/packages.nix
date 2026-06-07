{
  config,
  lib,
  ...
}: let
  inherit (config.ooknet.workstation) default programs;
  inherit (lib) optionals;
in {
  homebrew = {
    enable = true;
    caskArgs = {
      no_quarantine = true;
    };
    onActivation = {
      # uninstall package if removed from configuration
      cleanup = "uninstall";
    };
    enableFishIntegration = true;
    brews = [
      "uv"
      "poppler"
    ];
    casks =
      [
        "1password-cli"
        "raycast"
        "claude"
        "obsidian"
        "microsoft-teams"
        "slack"
        "moonlight"
      ]
      ++ optionals (default.terminal == "ghostty" || programs.ghostty.enable) ["ghostty"]
      ++ optionals (default.browser == "firefox" || programs.firefox.enable) ["firefox"]
      ++ optionals (default.browser == "zen" || programs.zen.enable) ["zen-browser"];
    masApps = {
      "Tailscale" = 1475387142;
    };
  };
}
