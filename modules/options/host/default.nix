{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str enum bool package;

  cfg = config.ooknet.host;

  userOptions = {
    name = mkOption {
      type = str;
      default = "ooks";
    };
    shell = mkOption {
      type = enum ["bash" "zsh" "fish"];
      default = "fish";
    };
    email = mkOption {
      type = str;
      default = "ooks@protonmail.com";
    };
    homeManager = mkOption {
      type = bool;
      default = false;
      description = ''
        Home-manager is enabled if ooknet.host.role == "workstation".
        If host is not a workstation and you would like to enable home-manager
        enable this option.
      '';
    };
  };
in {
  options.ooknet.host = {
    name = mkOption {
      type = str;
      default = "ooks-generic";
    };
    type = mkOption {
      type = enum ["vm" "desktop" "laptop" "iso"];
    };
    role = mkOption {
      type = enum ["workstation" "server" "installer" "live"];
    };

    system = mkOption {
      type = str;
      default = pkgs.stdenv.system;
      readOnly = true;
    };

    syncthing = {
      enable = mkEnableOption "Enable syncthing";
    };


    # mapping deploy-rs options
    deployment = {
      enable = mkEnableOption "Enable remote deployment";
      remoteBuild = mkEnableOption "Build the system on the target machine";
      fastConnection = mkEnableOption "Copy whole closrure instead of lettting node substitute";
      sshUser = mkOption {
        type = str;
        default = cfg.admin.name;
        description = "User that deploy-rs will use when connecting";
      };
    };

    boot = {
      loader = mkOption {
        type = enum ["systemd" "grub"];
        default = "systemd";
      };
      kernel = mkOption {
        type = package;
        default = pkgs.linuxPackages_latest;
      };
    };
    exitNode = mkOption {
      type = bool;
      default = false;
    };

    admin =
      userOptions
      // {
        gitName = mkOption {
          type = str;
          default = "ooks-io";
        };
        gitEmail = mkOption {
          type = str;
          default = "ooks@protonmail.com";
        };
      };
    guest =
      userOptions
      // {
        enable = mkEnableOption "Enable guest user";
      };
  };
}
