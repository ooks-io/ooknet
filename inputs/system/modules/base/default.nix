{ lib, ... }:

{
  imports = [
    ./shell
    ./boot
    ./nix
    ./programs
    ./displayManager
    ./networking
    ./locale.nix
    ./virtualization
    ./security
    ./services
    ./audio
    ./host
    ./video
  ];


  options.systemModules = {
    virtualisation = {
      enable = lib.mkEnableOption "Enable virtualisation module";
    };
  };
}
