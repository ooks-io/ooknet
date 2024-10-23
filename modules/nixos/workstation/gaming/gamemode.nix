{
  lib,
  config,
  pkgs,
  inputs',
  ...
}: let
  inherit (lib) optionalString elem getExe getExe' mkIf;
  inherit (config.ooknet.workstation) profiles environment;

  hyprctl = "${getExe' inputs'.hyprland.packages.hyprland "hyprctl"} -i 0";
  notify-send = getExe pkgs.libnotify;
  powerprofilectl = getExe pkgs.power-profiles-daemon;

  optimizeScriptStart = pkgs.writeShellScript "gamemode-start" ''
    ${optionalString (environment == "hyprland") ''
      ${hyprctl} -i 0 --batch "\
        keyword misc:vfr false; \
        keyword render:direct_scanout true; \
        keyword general:allow_tearing true" \
    ''}
    ${powerprofilectl} set performance
    ${notify-send} 'Gamemode Started'
  '';

  optimizeScriptStop = pkgs.writeShellScript "gamemode-end" ''
    ${optionalString (environment == "hyprland") ''
      ${hyprctl} -i 0 reload
    ''}
    ${powerprofilectl} set balanced
    ${notify-send} 'Gamemode Stopped'
  '';
in {
  config = mkIf (elem "gaming" profiles) {
    environment.systemPackages = [pkgs.power-profiles-daemon];
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 15;
          softrealtime = "auto";
        };
        custom = {
          start = optimizeScriptStart.outPath;
          end = optimizeScriptStop.outPath;
        };
      };
    };
  };
}
