{ ... }:


{
  imports = [
    ../../../profile
  ];

  theme.phone.enable = true;

  homeModules = {
    console.editor.helix.enable = true;
  };

  home.stateVersion = "23.11";
}

