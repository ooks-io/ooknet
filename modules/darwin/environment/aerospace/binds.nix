{
  pkgs,
  lib,
  ...
}: {
  services.aerospace.settings.mode.main.binding = let
    inherit (lib) getExe;
    mod = "cmd";
  in {
    "${mod}-left" = "focus left --boundaries all-monitors-outer-frame";
    "${mod}-right" = "focus right --boundaries all-monitors-outer-frame";
    "${mod}-up" = "focus up --boundaries all-monitors-outer-frame";
    "${mod}-down" = "focus down --boundaries all-monitors-outer-frame";
    "${mod}-1" = "workspace 1";
    "${mod}-2" = "workspace 2";
    "${mod}-3" = "workspace 3";
    "${mod}-4" = "workspace 4";
    "${mod}-5" = "workspace 5";
    "${mod}-6" = "workspace 6";
    "${mod}-7" = "workspace 7";
    "${mod}-8" = "workspace 8";
    "${mod}-9" = "workspace 9";

    "${mod}-shift-1" = "move-node-to-workspace 1";
    "${mod}-shift-2" = "move-node-to-workspace 2";
    "${mod}-shift-3" = "move-node-to-workspace 3";
    "${mod}-shift-4" = "move-node-to-workspace 4";
    "${mod}-shift-5" = "move-node-to-workspace 5";
    "${mod}-shift-6" = "move-node-to-workspace 6";
    "${mod}-shift-7" = "move-node-to-workspace 7";
    "${mod}-shift-8" = "move-node-to-workspace 8";
    "${mod}-shift-9" = "move-node-to-workspace 9";

    alt-f = "fullscreen";

    "${mod}-d" = "exec-and-forget open -a ${getExe pkgs.vesktop}";
  };
}
