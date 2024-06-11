{ lib, config, ... }:

let
  inherit (lib) mkIf;
  admin = config.ooknet.host.admin;
  cfg = config.ooknet.programs._1password;
in

{
  config = mkIf cfg.enable {
    programs = {
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ "${admin.name}" ];
      };
    };
  };
}
