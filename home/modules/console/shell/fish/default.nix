{ lib, config, osConfig, ... }:
let
  inherit (lib) mkIf any;
  cfg = config.ooknet.shell.fish;
  admin = osConfig.ooknet.host.admin;
  hasPackage = pname: any (p: p ? pname && p.pname == pname) config.home.packages;
  hasEza = hasPackage "eza";
  hasBat = hasPackage "bat";
in
{
  config = mkIf (cfg.enable || admin.shell == "fish") {
    programs.fish = {
      enable = true;
      shellAbbrs = {
        fe = "cd $FLAKE; $EDITOR $FLAKE";
        f = "cd $FLAKE";
        s = "cd $SCRIPTS";
        tree = mkIf hasEza "eza -T --icons --group-directories-first";
        ls = mkIf hasEza "eza -a --icons --group-directories-first";
        lsd = mkIf hasEza "eza -al --icons --group-directories-first";
        lst = mkIf hasEza "eza -T -L 5 --icons --group-directories-first";
        lsta = mkIf hasEza "eza -T --icons --group-directories-first";
        cat = mkIf hasBat "bat";
      };
      functions = {
        fish_greeting = "";
        fish_flake_edit = ''
        cd $FLAKE
        hx $FLAKE
        '';
        fish_hello_world = ''
          echo "Hello World"; string repeat -N \n --count=(math (count (fish_prompt)) - 1); commandline -f repaint
          '';

        fish_user_key_bindings = ''
          bind --preset -M insert \cf fish_flake_edit
          bind --preset -M insert \ec fzf_cd_widget
        '';
      };
      interactiveShellInit =
        # Use vim bindings and cursors
        ''
          fish_vi_key_bindings
          set fish_cursor_default     block      blink
          set fish_cursor_insert      line       blink
          set fish_cursor_replace_one underscore blink
          set fish_cursor_visual      block
        '' +
        # Use terminal colors
        ''
          set -U fish_color_autosuggestion      brblack
          set -U fish_color_cancel              -r
          set -U fish_color_command             brgreen
          set -U fish_color_comment             brmagenta
          set -U fish_color_cwd                 green
          set -U fish_color_cwd_root            red
          set -U fish_color_end                 brmagenta
          set -U fish_color_error               brred
          set -U fish_color_escape              brcyan
          set -U fish_color_history_current     --bold
          set -U fish_color_host                normal
          set -U fish_color_match               --background=brblue
          set -U fish_color_normal              normal
          set -U fish_color_operator            cyan
          set -U fish_color_param               brblue
          set -U fish_color_quote               yellow
          set -U fish_color_redirection         bryellow
          set -U fish_color_search_match        'bryellow' '--background=brblack'
          set -U fish_color_selection           'white' '--bold' '--background=brblack'
          set -U fish_color_status              red
          set -U fish_color_user                brgreen
          set -U fish_color_valid_path          --underline
          set -U fish_pager_color_completion    normal
          set -U fish_pager_color_description   yellow
          set -U fish_pager_color_prefix        'white' '--bold' '--underline'
          set -U fish_pager_color_progress      'brwhite' '--background=cyan'
        '';
    };
  };
}
 
