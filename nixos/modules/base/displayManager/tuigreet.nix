{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf;
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  host = config.ooknet.host;
in
{
  config = mkIf (host.type != "phone") {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --time --remember --cmd Hyprland"; # TODO: dont hardcode this
          user = "greeter";
        };
      };
    };

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
