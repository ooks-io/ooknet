{
  config,
  lib,
  withSystem,
  inputs,
  self,
  ooknetModules,
  ...
}: let
  inherit (lib) mapAttrs mkDefault singleton optionals;
  inherit (builtins) concatLists;
  inherit (self) hozen ook;
  inherit (ooknetModules) nixosMinimal isoModules nixos hostModules;

  buildImage = hostname: cfg:
    withSystem cfg.system ({
      inputs',
      self',
      ...
    }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs =
          {
            inherit hozen ook inputs self inputs' self';
          }
          // cfg.additionalArgs;

        modules = concatLists [
          (singleton {
            networking.hostName = hostname;
            nixpkgs = {
              flake.source = inputs.nixpkgs.outPath;
              hostPlatform = mkDefault cfg.system;
            };
            ooknet.host = {
              name = hostname;
              role = cfg.role;
              type = cfg.type;
            };
          })
          nixosMinimal
          (optionals (cfg.type == "iso") isoModules)
          (optionals (cfg.role == "installer") [(nixos.image + "/installer.nix")])
          (
            if cfg.profile != null
            then [(hostModules + "/${cfg.profile}")]
            else [(hostModules + "/${hostname}")]
          )
          cfg.additionalModules
        ];
      });
in {
  config.flake.nixosConfigurations = mapAttrs buildImage config.flake.ooknet.images;
}
