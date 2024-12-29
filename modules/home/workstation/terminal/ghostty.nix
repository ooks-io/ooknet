{
  inputs,
  inputs',
  ...
}: {
  imports = [
    inputs.ghostty-hm.homeModules.default
  ];

  programs.ghostty = {
    enable = true;
    package = inputs'.ghostty.packages.default;
  };
}
