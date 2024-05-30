{ pkgs, config, lib, ... }:
  let 
    cfg = config.ooknet.console.utility.git;
  in
{ 
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "ooks-io";
      userEmail = "ooks@protonmail.com";
      extraConfig = {
        gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
      ignores = [ ".direnv" "result" ];
      lfs.enable = true;
    };
  
    home.packages = with pkgs; [
      lazygit
    ];
  };
}

