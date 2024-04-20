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
      multiplexer.zellij.enable = true;
    };
    config.nix.enable = true;
  };

  home.stateVersion = "23.11";
}

