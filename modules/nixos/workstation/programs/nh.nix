{config, ...}: let
  inherit (config.ooknet.host) admin;
in {
  programs.nh = {
    enable = true;
    flake = "/home/${admin.name}/.config/ooknet";
  };
}
