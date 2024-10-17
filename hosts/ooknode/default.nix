{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  ooknet.host = {
    name = "ooksnode";
    type = "vm";
    role = "server";
    profiles = ["console-tools"];
    admin = {
      name = "ooks";
      shell = "fish";
      homeManager = true;
    };
    networking = {
      tailscale = {
        enable = true;
        client = true;
        autoconnect = true;
      };
    };
    hardware = {
      cpu.type = "intel";
      features = [
        "ssd"
      ];
    };
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  system.stateVersion = mkDefault "23.11";
}
