{self, ...}: {
  flake.images = {
    ooknode = self.nixosConfigurations.ooknode.config.system.build.image;
  };
}
