{ pkgs, lib, config, ... }:
let
  cfg = config.homeModules.console.utility.tools;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bc # Calculator
    
      # file utility
      duf
      du-dust
      fd
      ripgrep

      # archive
      zip
      unzip
      unrar
    
      # file transfer
      wget
      httpie # Better curl

      # resource manager
      powertop
    
      diffsitter # Better diff
      jq # JSON pretty printer and manipulator
      comma # Install and run with ","
      tldr # Community maintained help pages
      progress
      killall
      acpi

      # Nix tooling
      alejandra
    ];

    programs = {
      btop.enable = true;
      eza.enable = true;
      bat = {
        enable = true;
        config = {
          theme = "base16";
          pager = "less -FR";
        };
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      skim = {
        enable = true;
        enableFishIntegration = lib.mkIf config.programs.console.shell.fish.enable true;
        defaultCommand = "rg --files --hidden";
        changeDirWidgetOptions = [
          "--preview 'eza --icons -L 3 -T --color always {} | head -200'"
          "--exact"
        ];
        fileWidgetCommand = "rg --files";
        fileWidgetOptions = [
          "--preview 'bat --color=always {}'"
        ];
      };
    };
  };
}
