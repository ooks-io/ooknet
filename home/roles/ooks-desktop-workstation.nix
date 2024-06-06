{ lib, config, osConfig, ... }:

let
  inherit (lib) mkIf;
  host = osConfig.ooknet.host;
in

{
  config = mkIf (host.admin.name == "ooks" && host.type == "desktop" && host.role == "workstation") {
    ooknet = {
      theme = "minimal";
      desktop = {
        environment = "hyprland";
        browser = "firefox";
        terminal = "foot";
        notes = "obsidian";
        pdf = "zathura";
        discord = "vesktop";
      };
      console = {
        editor = "helix";
        multiplexer = "zellij";
      };
    };
  };
}
