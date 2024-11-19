{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShellNoCC {
      name = "project devshell";
      packages =
        builtins.attrValues {
        };
    };
  };
}
