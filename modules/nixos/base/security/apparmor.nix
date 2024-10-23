{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) getExe;
in {
  security = {
    apparmor = {
      enable = true;

      # packages to include with apparmors path
      packages = [pkgs.apparmor-profiles];

      # kill any process that does not have a apparmor profile enabled
      killUnconfinedConfinables = true;

      # apparmor policies
      # FIXME
      policies = {
        "default_deny" = {
          enforce = false;
          enable = false;
          profile = ''
            profile default_deny /** { }
          '';
        };
        "nix" = {
          enforce = false;
          enable = false;
          profile = ''
            ${getExe config.nix.package} {
              unconfined,
            }
          '';
        };
        "sudo" = {
          enforce = false;
          enable = false;
          profile = ''
            ${getExe pkgs.sudo} {
              file /** rwlkUx,
            }
          '';
        };
      };
    };
  };

  # enable apparmor mode for dbus
  services.dbus.apparmor = "enabled";

  # apparmor packages to add to path
  environment.systemPackages = attrValues {
    inherit
      (pkgs)
      apparmor-utils
      apparmor-bin-utils
      apparmor-kernel-patches
      apparmor-parser
      apparmor-profiles
      apparmor-pam
      libapparmor
      ;
  };
}
