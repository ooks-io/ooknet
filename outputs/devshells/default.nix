{
  perSystem = {pkgs, ...}: {
    devShells = {
      website = pkgs.mkShellNoCC (import ./website.nix {inherit pkgs;});
    };
  };
}
