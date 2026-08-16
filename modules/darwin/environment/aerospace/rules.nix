{
  config,
  lib,
  ...
}: let
  inherit (config.ooknet.workstation) default profiles;
  inherit (lib) optional elem;
in {
  services.aerospace.window-rules =
    [
      {
        conditions.id = "com.1password.1password";
        float = true;
      }
      {
        conditions.id = "com.apple.finder";
        float = true;
      }
      {
        conditions.id = "com.tinyspeck.slackmacgap";
        workspace = 5;
      }
      {
        conditions.id = "com.microsoft.teams2";
        workspace = 5;
      }
    ]
    ++ optional (default.browser == "zen") {
      conditions.id = "app.zen-browser.zen";
      workspace = 2;
    }
    ++ optional (default.terminal == "ghostty") {
      conditions.id = "com.mitchellh.ghostty";
      workspace = 1;
    }
    ++ optional (elem "communication" profiles) {
      conditions.id = "dev.vencord.vesktop";
      workspace = 4;
    };
}
