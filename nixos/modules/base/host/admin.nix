{ lib, config, pkgs, inputs, outputs, self, ... }:

let
  cfg = config.ooknet.host.admin;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  inherit (lib) mkIf types mkOption;
in

{
  options.ooknet.host.admin = {
    name = mkOption {
      type = types.str;
      default = "ooks";
      description = "Name of the primary user";
    };
    shell = mkOption {
      type = types.enum ["fish" "bash" "zsh"];
      default = "zsh";
      description = "The login shell of the primary user";
    };
    gitName = mkOption {
      type = types.str;
      default = "ooks-io";
      description = "Github username of admin";
    };
    gitEmail = mkOption {
      type = types.str;
      default = "ooks@protonmail.com";
      description = "Github email of admin";
    };
    sshKey = mkOption {
      type = types.str;
      default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
      description = "The ssh key for the admin user";
    };
    homeManager = mkOption {
      type = types.bool;
      default = false;
      description = "Enables home manager module for the admin user";
    };
  };

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      shell = pkgs.${cfg.shell};
      initialPassword = "password";
      openssh.authorizedKeys.keys = [ "${cfg.sshKey}" ];
      extraGroups = [
        "wheel"
        "video"
        "audio"
        ] ++ ifTheyExist [
        "git"
        "media"
        "network"
        "libvirtd"
        "deluge"
        "streamer"
        "torrenter"
      ];
    };
    home-manager = mkIf cfg.homeManager {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm.old";
      verbose = true;
      extraSpecialArgs = { inherit inputs outputs self; };
      users.${cfg.name} = {
        imports = [ "${self}/home" ];
      };
    };
  };
}
