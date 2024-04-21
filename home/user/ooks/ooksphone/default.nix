{ pkgs, ... }:


{
  imports = [
    ../../../profile
  ];
  
  theme.phone.enable = true;

  homeModules = {
    console = {
      editor.helix.enable = true;
      shell.fish.enable = true;
      prompt.starship.enable = true;
      multiplexer.zellij.enable = true;
      utility = {
        tools.enable = true;
      };
    };
    config.nix.enable = true;
  };
  home.packages = with pkgs; [
    pfetch
    lazygit
  ];
  programs = {
    ssh.enable = true;
    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "ooks-io";
      userEmail = "ooks@protonmail.com";
      ignores = [ ".direnv" "result" ];
      lfs.enable = true;
    };
  };

  home.shellAliases = {
    nrs = "nix-on-droid switch --flake $FLAKE";
  };

  home.sessionVariables = {
    TZ = "Pacific/Auckland";
    FLAKE = "$HOME/.config/ooknix";
  };

  home.stateVersion = "23.11";
}

