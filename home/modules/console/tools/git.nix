{ pkgs, config, lib, osConfig, ... }:

  let 
    inherit (lib) mkIf;
    cfg = config.ooknet.tools.git;
    admin = osConfig.ooknet.host.admin;
  in
  
{ 
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = admin.gitName;
      userEmail = admin.gitEmail;
      ignores = [ ".direnv" "result" ];
      lfs.enable = true;
    };
  
    home.packages = with pkgs; [
      lazygit
      gh
    ];
  };
}

