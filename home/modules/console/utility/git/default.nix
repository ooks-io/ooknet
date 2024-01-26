{ pkgs, config, lib, ... }:
  let 
    cfg = config.homeModules.console.utility.git;
  in
{ 
  config = {
    programs.git = lib.mkIf cfg.enable {
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
      git-credential-1password
      ];
  };
}

