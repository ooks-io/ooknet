{ inputs, ... }: {

  imports = [
    inputs.nh.nixosModules.default
  ];

  environment.variables.FLAKE = "/home/ooks/Coding/nix/ooks-io/nix";

  nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
  };
}
