{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe';
  inherit (config.ooknet.workstation) sunshine;

  hyprctl = getExe' config.programs.hyprland.package "hyprctl";
  systemctl = getExe' pkgs.systemd "systemctl";

  # sunshine runs prep cmds without a shell, so wrap them in a script
  # never fail the stream over a convenience cmd, hence the `|| true`
  prepDo = pkgs.writeShellScript "sunshine-prep-do" ''
    ${hyprctl} dispatch dpms on || true
    ${systemctl} --user stop hypridle.service || true
  '';
  prepUndo = pkgs.writeShellScript "sunshine-prep-undo" ''
    ${systemctl} --user start hypridle.service || true
  '';
in {
  config = mkIf sunshine.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      # CAP_SYS_ADMIN for KMS/DRM capture on wayland
      capSysAdmin = true;
      # reachable over the trusted tailscale0 interface, pair locally via https://localhost:47990
      openFirewall = false;
      # wake the display and pause hypridle for the duration of a stream
      # sunshine wants this as a json string, not a nix list
      settings.global_prep_cmd = builtins.toJSON [
        {
          do = "${prepDo}";
          undo = "${prepUndo}";
        }
      ];
    };

    # vainfo, to verify vaapi encode is picked up
    environment.systemPackages = [pkgs.libva-utils];
  };
}
