let
  subcommands = "not __fish_seen_subcommand_from search s daily d backup b";
in {
  programs.fish = {
    interactiveShellInit =
      #fish
      ''
        complete -c notes -e
        complete -c notes -f
        complete -c notes -n "${subcommands}" -a "search" -d "Open Neovim with Obsidian quick switcher"
        complete -c notes -n "${subcommands}" -a "daily" -d "Open todays daily note"
        complete -c notes -n "${subcommands}" -a "backup" -d "Push changes to remote"

        complete -c notes -n "__fish_seen_subcommand_from open o" -a "(ls $XDG_NOTES_DIR/**.md | fzf)"
      '';
    functions.notes = {
      description = "Access my notes repository";
      body =
        #fish
        ''
          if test (count $argv) -gt 0
            switch $argv[1]
              case search s
                cd $XDG_NOTES_DIR
                nvim -c 'ObsidianQuickSwitch'
              case d daily
                cd $XDG_NOTES_DIR
                nvim -c 'ObsidianToday'
              case b backup
                cd $XDG_NOTES_DIR
                git add .
                git commit -m "$(date)"
                git push
              case '*'
                echo "Unknown subcommand: $argv[1]"
            end
          else
            cd $XDG_NOTES_DIR
          end
        '';
    };
  };
}
