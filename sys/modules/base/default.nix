{ lib, ... }:

{
  imports = [
    ./shell
    ./boot
    ./nix
    ./displayManager
    ./networking
    ./locale.nix
    ./virtualization
    ./security
    ./services
    ./host
  ];


  options.systemModules = {
    virtualisation = {
      enable = lib.mkEnableOption "Enable virtualisation module";
    };
  };
}
