{ lib, config, ... }:

let
  cfg = config.systemModules.user.shell;
in

{
  imports = [
    ./fish
    # ./bash
    # ./zsh
  ];

  options.systemModules.user.shell = {
    fish = {
      enable = lib.mkEnableOption "Enable fish as the user shell";
    };
    zsh = {
      enable = lib.mkEnableOption "Enable zsh as the user shell";
    };
    bash = {
      enable = lib.mkEnableOption "Enable bash as the user shell";
    };

  };

   config = { 
    assertions = [
      {
        assertion = 
          (lib.length (lib.filter (x: x) [
            cfg.fish.enable or false
            cfg.zsh.enable or false
            cfg.bash.enable or false
          ]) <= 1); 
        message = "Only one user shell can be active in the configuration";
      }
    ];
  };
}
