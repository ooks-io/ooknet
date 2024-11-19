{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShellNoCC {
      name = "project devshell";
      packages = builtins.attrValues {
        inherit (pkgs) go gopls gotools go-tools;
      };
    };
  };
}
