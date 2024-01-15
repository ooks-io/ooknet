{ lib, ... }:

{
  imports = [
    ./nh.nix
    ./nix.nix
    ./nixpkgs
    ./subs.nix
  ];

  options.systemModules.nixOptions = {
    enable = lib.mkEnableOption "Enable nix related configuration modules";
  };
}
