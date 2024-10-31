{pkgs, ...}: let
  inherit (builtins) attrValues;
in {
  name = "ooknet website devshell";
  packages = attrValues {
    inherit (pkgs) zola;
  };
  shellHook = ''
    echo "Entering website devshell";
    cd $WEBSITE/src
    echo "Serving website"
    zola serve
  '';
}
