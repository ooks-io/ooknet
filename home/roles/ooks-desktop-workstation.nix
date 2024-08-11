{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet) host;
in {
  config = mkIf (host.admin.name == "ooks" && host.type == "desktop" && host.role == "workstation") {
    ooknet = {
      desktop = {
        environment = "hyprland";
        browser = "firefox";
        terminal = "foot";
        notes = "obsidian";
        pdf = "zathura";
        discord = "vesktop";
        fileManager = "nemo";
      };
      console = {
        editor = "helix";
        multiplexer = "zellij";
      };
    };
  };
}
