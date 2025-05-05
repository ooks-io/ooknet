{
  inputs,
  self,
  lib,
  ...
}: let
  inherit (lib) filterAttrs mapAttrs elem;

  mkNode = hostname: cfg: let
    inherit (cfg.config.ooknet.host) system;
    deployLib = inputs.deploy-rs.lib.${system};
  in {
    inherit hostname;
    inherit (cfg.config.ooknet.host.deployment) remoteBuild fastConnection;
    profiles.system = {
      path = deployLib.activate.nixos cfg;
    };
  };
  nodes = let
    allowedTargets = [
      "ooksmedia"
      "ooksdesk"
      "ooknode"
      "ookst480s"
    ];
    deployableTargets = filterAttrs (name: _: elem name allowedTargets) self.nixosConfigurations;
  in
    mapAttrs mkNode deployableTargets;
in {
  flake = {
    deploy = {
      inherit nodes;
      magicRollback = true;
      autoRollback = true;
      user = "root";
    };

    #checks = mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
