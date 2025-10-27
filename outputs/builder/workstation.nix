{
  config,
  lib,
  withSystem,
  inputs,
  self,
  ooknetModules,
  ...
}: let
  inherit (lib) mapAttrs mkDefault filterAttrs;
  inherit (builtins) concatLists singleton;
  inherit (self) hozen ook;
  inherit (ooknetModules) nixosCore darwinCore common nixos hostModules;

  buildWorkstation = hostname: cfg:
    withSystem cfg.system ({
      inputs',
      self',
      ...
    }: let
      isDarwin = cfg.system == "aarch64-darwin";

      mkSystem =
        if isDarwin
        then inputs.nix-darwin.lib.darwinSystem
        else inputs.nixpkgs.lib.nixosSystem;

      platformModules =
        if isDarwin
        then darwinCore ++ [common.workstation]
        else nixosCore ++ [nixos.workstation common.workstation];
    in
      mkSystem {
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
              role = "workstation";
              type = cfg.type;
            };
          })
          platformModules
          [(hostModules + "/${hostname}")]
          cfg.additionalModules
        ];
      });
in {
  config = let
    workstations = config.flake.ooknet.workstations;
    nixosWorkstations = filterAttrs (_: cfg: cfg.system != "aarch64-darwin") workstations;
    darwinWorkstations = filterAttrs (_: cfg: cfg.system == "aarch64-darwin") workstations;
  in {
    flake.nixosConfigurations = mapAttrs buildWorkstation nixosWorkstations;
    flake.darwinConfigurations = mapAttrs buildWorkstation darwinWorkstations;
  };
}
