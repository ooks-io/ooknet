{ pkgs, inputs, outputs, ... }:

{
  imports = [ ./theme.nix ];

  environment.packages = with pkgs; [
    git
    killall
    hostname
    man
    coreutils
  ];

  environment.etcBackupExtension = ".bak";

  system.stateVersion = "23.11";

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    substituters = [
      "https://cache.nixos.org?priority=10"
      "https://helix.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trustedPublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  
  time.timeZone = "Pacific/Auckland";

  user = {
    shell = "${pkgs.fish}/bin/fish";
  };

  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs outputs; };
    config = import ../../../home/user/ooks/ooksphone;
  };
}
