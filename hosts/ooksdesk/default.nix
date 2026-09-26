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
    system.earlyoom.enable = true;
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
      sunshine.enable = true;
      silentBoot.enable = true;
      profiles = ["creative" "virtualization" "gaming" "media" "communication" "productivity" "infra" "work" "ai" "3dprinting"];
      default = {
        browser = "zen";
        terminal = "ghostty";
      };
      programs = {
        firefox.enable = true;
        chromium.enable = true;
      };
    };
    console = {
      profile = "standard";
      editor = "nvim";
      multiplexer = "zellij";
    };
    virtualization = {
      host = {
        enable = true;
        ooknet-install-vm.enable = false;
        virt-manager.enable = true;
        containers.enable = true;
      };
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  # build aarch64 images (ookspi)
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  system.stateVersion = lib.mkDefault "24.11";
}
