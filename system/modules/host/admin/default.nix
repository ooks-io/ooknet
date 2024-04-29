{ lib, config, pkgs, ... }:

let
  cfg = config.systemModules.host.admin;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  inherit (lib) types mkOption;
in

{
  options.systemModules.host.admin = {
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
    sshKey = mkOption {
      type = types.str;
      default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
      description = "The ssh key for the admin user";
    };
  };

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      shell = pkgs.${cfg.shell};
      initialPassword = "password";
      openssh.authorizedKeys = "${cfg.sshKey}";
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
  };
}
