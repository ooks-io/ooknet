{
  imports = [
    ./rofi.nix
    ./hyprcapture.nix
    # ./mako.nix # replaced by ookshell notifications
    ./tools.nix
    ./ookshell
    # ./waybar.nix # replaced by ookshell, kept for reference/fallback
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./gammastep.nix
    ./polkit.nix
  ];
}
