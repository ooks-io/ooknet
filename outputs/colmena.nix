{
  inputs,
  self,
}: {
  flake.colmena = {
    meta = {
      description = "ooknet colmena hive";
      nixpkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    };
    inherit (self.nixosConfigurations.system.build.toplevel) ooksdesk ooknode ooksmedia ookst480s;
  };
}
