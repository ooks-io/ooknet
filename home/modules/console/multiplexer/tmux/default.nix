{ config, lib, pkgs, ... }:

let
  inherit (config.colorscheme) palette;
  inherit (lib) mkIf;
  cfg = config.ooknet.multiplexer.tmux;
  console = config.ooknet.console;
in

{
  config = mkIf (cfg.enable || console.multiplexer == "tmux") {
    programs.tmux = {
      enable = true;
      shell = "${pkgs.fish}/bin/fish";
      prefix = "C-space";
      baseIndex = 1;
      keyMode = "vi";
      escapeTime = 0;
      mouse = true;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.mode-indicator;
        }
      ];
      extraConfig = /* sh */ ''
        # General Settings
        set -g set-clipboard on
        #Appearance
        set -g status-position top
        set -g status-style "fg=#${palette.base05} bg=#${palette.base00}"
        #Windows
        set -g status-justify "centre"
        setw -g window-status-current-format "#[bg=#${palette.base0B},fg=#${palette.base00},bold] #W "
        setw -g window-status-format "#[bg=#${palette.base03},fg=#${palette.base05}] #W "
        #Left
        set -g status-left " #{tmux_mode_indicator} #[bg=#${palette.base0B},fg=#${palette.base00}] #S"
        set -g status-right '%Y-%m-%d %H:%M #{tmux_mode_indicator}'
        #Move to Pane
        bind -n M-Left select-pane -L
        bind -n M-h select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-l select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-k select-pane -U
        bind -n M-Down select-pane -D
        bind -n M-j select-pane -D
        #Split Pane
        bind -n M-- split-window -h
        bind -n M-= split-window -v
        #Resize Pane
        bind -n C-M-Up resize-pane -U 5
        bind -n C-M-Down resize-pane -D 5
        bind -n C-M-Left resize-pane -L 5
        bind -n C-M-Right resize-pane -R 5
        #Move to Window
        bind -n M-1 
      '';
    };
  };
}
