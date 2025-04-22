{
  config,
  lib,
  ...
}: let
  inherit (config.ooknet.workstation) default profiles;
  inherit (lib) optionals elem;
in {
  services.aerospace.window-rules = [
    {
      conditions.id = "com.1password.1password";
      float = true;
    }
    {
      conditions.id = "com.apple.finder";
      float = true;
    }
    (optionals (default.browser == "zen") {
      conditions.id = "app.zen-browser.zen";
      workspace = 2;
    })
    (optionals (default.terminal == "ghostty") {
      conditions.id = "com.mitchell.ghostty";
      workspace = 1;
    })
    (optionals (elem "communication" profiles) {
      conditions.id = "dev.vencord.vesktop";
      workspace = 4;
    })
  ];
}
