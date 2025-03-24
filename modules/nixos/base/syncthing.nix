{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.networking) hostName;
  inherit (config.ooknet.host) admin syncthing;
  inherit (config.ooknet.secrets) devices;

  key = config.age.secrets."${hostName}-syncthing-key";
  cert = config.age.secrets."${hostName}-syncthing-cert";
in {
  config = mkIf syncthing.enable {
    services.syncthing = {
      enable = true;
      user = admin.name;
      group = "users";
      openDefaultPorts = true;
      configDir = "/home/${admin.name}/.config/syncthing";

      # host credentials
      key = key.path;
      cert = cert.path;

      settings = {
        # obfuscating device ids is not necessary, but i do it anyway

        # to generate a new device id run:
        # syncthing generate
        devices = {
          "ooksdesk" = {
            inherit (devices.ooksdesk) id addresses;
          };
          "ooksmedia" = {
            inherit (devices.ooksmedia) id addresses;
          };
          "ookst480s" = {
            inherit (devices.ookst480s) id addresses;
          };
        };
        folders = {
          "Summit" = {
            path = "/home/${admin.name}/Summit";
            devices = [
              "ooksdesk"
              "ooksmedia"
            ];
            ignorePerms = false;
          };
        };
      };
    };
    # Dont create default ~/Sync folder
    # https://wiki.nixos.org/wiki/Syncthing
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  };
}
