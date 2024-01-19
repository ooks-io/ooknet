{ lib, config, pkgs, ... }: 
let
  cfg = config.programs.desktop.wayland.windowManager.hyprland;
in
{
    imports = [
      ./binds.nix #hyprland keybindings
      ./appearance.nix
      ./rules.nix
      ./exec.nix
      ];

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      extraPortals = [ pkgs.inputs.hyprland.xdg-desktop-portal-hyprland ];
      configPackages = [ pkgs.inputs.hyprland.hyprland ];
    };

    home.packages = with pkgs; [
      inputs.hyprwm-contrib.grimblast
      hyprpicker
      ];
    
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.inputs.hyprland.hyprland;
      systemd = {
        enable = true;
        extraCommands = lib.mkBefore [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };
      settings = {
        input = {
          kb_layout = "us";
          touchpad = {
            disable_while_typing = false;
          };
        };
        
        misc = {
          vrr = true;
          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
        };
        
        gestures = {
          workspace_swipe = true;
          workspace_swipe_forever = true;
        };
        
        monitor = lib.concatMap (m: let
          resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = "${toString m.x}x${toString m.y}";
          basicConfig = "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}";
        in
          [ basicConfig ] ++ (if m.transform != 0 then ["${m.name},transform,${toString m.transform}"] else [])
        ) (config.monitors);
      };
    };
  };
}
