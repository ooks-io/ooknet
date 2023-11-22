{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./nvim.nix
    ./fzf.nix
    ./git.nix
    ./bash.nix
    ./fish.nix
    ./pfetch.nix
    ./starship.nix
    ./joshuto
    ./helix
  ];
  home.packages = with pkgs; [
    bc # Calculator
    ncdu # disk util
    eza # Ls
    fd # Find
    ripgrep # Better grep
    httpie # Better curl
    diffsitter # Better diff
    jq # JSON pretty printer and manipulator
    lazygit # Better git
    comma # Install and run with ","
    btop # Resource manager
    tldr # Community maintained help pages
    tmux # Terminal multiplexer
    tre-command # Better tree
    unzip
    progress
    killall
    gcc
    wget 
    powertop
    acpi
    
  ];
}