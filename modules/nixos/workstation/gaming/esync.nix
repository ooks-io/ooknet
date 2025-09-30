{
  config,
  lib,
  ...
}: let
  inherit (config.ooknet.host) admin;
  inherit (lib) mkIf elem;
  inherit (config.ooknet.workstation) profiles;
in {
  config = mkIf (elem "gaming" profiles) {
    systemd.settings.Manager.DefaultLimitNOFILE = 524288;
    security.pam.loginLimits = [
      {
        domain = admin.name;
        type = "hard";
        item = "nofile";
        value = "524288";
      }
    ];
  };
}
