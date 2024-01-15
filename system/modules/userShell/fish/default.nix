{ pkgs, ... }:
{
  users.users.ooks.shell = pkgs.fish;
  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };
}
