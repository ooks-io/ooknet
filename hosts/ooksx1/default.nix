{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./file-system.nix
    ./hardware.nix
  ];

  ooknet = {
    host = {
      admin = {
        name = "ooks";
        shell = "fish";
        homeManager = false;
      };
      guest = {
        enable = true;
        name = "eureka";
        homeManager = true;
        shell = "fish";
      };
    };
    workstation = {
      environment = "gnome";
      theme = "minimal";
      default = {
        browser = "chromium";
        terminal = "ghostty";
      };
    };
    console = {
      profile = "standard";
      editor = "nvim";
      multiplexer = "zellij";
    };
  };
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  system.stateVersion = lib.mkDefault "24.11";
}
