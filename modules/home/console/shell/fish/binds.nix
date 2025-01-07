{
  programs.fish = {
    functions = {
      fish_user_key_bindings = ''
        bind --preset -M insert \cf gitedit
        bind --preset -M insert \ec fzf_cd_widget
      '';
    };
  };
}
