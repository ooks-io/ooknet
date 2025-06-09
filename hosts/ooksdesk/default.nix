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
      deployment = {
        enable = true;
        remoteBuild = true;
      };
      syncthing.enable = true;
      admin = {
        name = "ooks";
        shell = "fish";
        homeManager = true;
      };
    };
    workstation = {
      environment = "hyprland";
      theme = "minimal";
      profiles = ["creative" "virtualization" "gaming" "media" "communication" "productivity" "infra"];
      default = {
        browser = "zen";
        terminal = "foot";
      };
      programs.firefox.enable = true;
    };
    console = {
      profile = "standard";
      editor = "nvim";
      multiplexer = "zellij";
    };
    virtualization = {
      host = {
        enable = true;
        ooknet-install-vm.enable = true;
        virt-manager.enable = true;
        containers.enable = true;
      };
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  system.stateVersion = lib.mkDefault "24.11";
}
