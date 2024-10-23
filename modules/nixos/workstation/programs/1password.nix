{config, ...}: let
  inherit (config.ooknet.host) admin;
in {
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["${admin.name}"];
    };
  };
}
