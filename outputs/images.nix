{self, ...}: {
  flake.images = {
    ooknode = self.nixosConfigurations.ooknode.config.system.build.image;
    ooksinstall = self.nixosConfigurations.ooksinstall.config.system.build.isoImage;
    ookspi = self.nixosConfigurations.ookspi.config.system.build.sdImage;
  };
}
