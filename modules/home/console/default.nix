{
  imports = [
    ./shell
    ./tools
    # console tools read ooknet.appearance, servers dont import home/common
    ../common/appearance.nix # FIXME: this smells
  ];
}
