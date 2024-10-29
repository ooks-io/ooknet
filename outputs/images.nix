{
  ook,
  self,
  ...
}: let
  inherit (ook.lib.builders) mkImage;
in {
  flake.images = {
    ooknode = self.nixosConfigurations.ooknode.config.system.build.image;
  };
}
