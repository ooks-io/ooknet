{ lib, ... }: 

let
  inherit (lib) mkDefault mkForce;
in

{
  # nyx module
  security = {
    sudo-rs.enable = mkForce false; # we don't want the rust sudo fork
    sudo = {
      enable = true;
      wheelNeedsPassword = mkDefault false; # only use false here if the extraRules below are enabled
      execWheelOnly = mkForce true; # only allow wheel to execute sudo
      extraConfig = /* shell */ ''
        Defaults lecture = never # disable sudo lecture
        Defaults pwfeedback # password feedback
        Defaults env_keep += "EDITOR PATH DISPLAY" # variables to be passes to root
        Defaults timestamp_timeout = 300 # asks for sudo password ever 300s
      '';
      extraRules = [
        {
          # allow wheel group to run nixos-rebuild without password
          groups = ["wheel"];
          commands = let
            currentSystem = "/run/current-system/";
            storePath = "/nix/store/";
          in [
            {
              command = "${storePath}/*/bin/switch-to-configuration";
              options = ["SETENV" "NOPASSWD"];
            }
            {
              command = "${currentSystem}/sw/bin/nix-store";
              options = ["SETENV" "NOPASSWD"];
            }
            {
              command = "${currentSystem}/sw/bin/nix-env";
              options = ["SETENV" "NOPASSWD"];
            }
            {
              command = "${currentSystem}/sw/bin/nixos-rebuild";
              options = ["NOPASSWD"];
            }
            {
              # let wheel group collect garbage without password
              command = "${currentSystem}/sw/bin/nix-collect-garbage";
              options = ["SETENV" "NOPASSWD"];
            }
            {
              # let wheel group interact with systemd without password
              command = "${currentSystem}/sw/bin/systemctl";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };
}
