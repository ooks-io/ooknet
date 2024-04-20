{ inputs, outputs, config, ... }:

{
  imports = [
    ../../../modules
  ];

  homeModules = {
    console.editor.helix.enable = true;
  };

  home.sessionVariables.HN = "ooksphone";

  home.stateVersion = "23.11";
}

