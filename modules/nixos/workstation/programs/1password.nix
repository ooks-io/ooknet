{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.workstation.programs) zen;
  inherit (config.ooknet.workstation.default) browser;
  inherit (config.ooknet.host) admin;
in {
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["${admin.name}"];
    };
  };
  environment.etc."1password/custom_allowed_browsers" = mkIf (zen.enable || browser == "zen") {
    text = ''
      .zen-wrapped
    '';
    mode = "0755";
  };
}
