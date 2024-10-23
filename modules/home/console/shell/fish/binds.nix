{
  programs.fish = {
    functions = {
      fish_user_key_bindings = ''
        bind --preset -M insert \cf nvim '+Telescope find_files' $FLAKE
        bind --preset -M insert \ec fzf_cd_widget
      '';
    };
  };
}
