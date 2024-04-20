{ ... }:


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
      # FIXME: multiplexer.zellij.enable = true;
      utility = {
        tools.enable = true;
      };
    };
    config.nix.enable = true;
  };

  home.stateVersion = "23.11";
}

