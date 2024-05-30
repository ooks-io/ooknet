{ config, lib, ... }:

let
  cfg = config.ooknet.console.prompt.starship;
  inherit (lib) concatStrings mkEnableOption mkIf;
in

{
  options.ooknet.console.prompt.starship.enable = mkEnableOption "";
  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        format = concatStrings [
          "$username"
          "$hostname"
          "$nix_shell"
          "$shlvl"
          "$directory"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_status"
          "$jobs"
          "$character"
        ];

        directory = {
          truncation_length = 0;
          truncate_to_repo = true;
        };

        fill = {
          symbol = " ";
          disabled = false;
        };

        character = {
          error_symbol = "[](bold red)";
          success_symbol = "[](bold green)";
          vimcmd_symbol = "[](bold yellow)";
          vimcmd_visual_symbol = "[](bold cyan)";
          vimcmd_replace_symbol = "[](bold purple)";
          vimcmd_replace_one_symbol = "[](bold purple)";
        };

        aws.symbol = "  ";
        conda.symbol = " ";
        dart.symbol = " ";
        directory.read_only = "  ";
        docker_context.symbol = " ";
        elixir.symbol = " ";
        elm.symbol = " ";
        gcloud.symbol = " ";
        git_branch.symbol = " ";
        golang.symbol = " ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        memory_usage.symbol = "󰍛 ";
        nim.symbol = "󰆥 ";
        nodejs.symbol = " ";
        package.symbol = "󰏗 ";
        perl.symbol = " ";
        php.symbol = " ";
        python.symbol = " ";
        ruby.symbol = " ";
        rust.symbol = " ";
        scala.symbol = " ";
        shlvl.symbol = "";
        swift.symbol = "󰛥 ";
        terraform.symbol = "󱁢";
      };
    };
  };
}

