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

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

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
