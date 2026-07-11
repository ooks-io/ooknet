{
  self,
  pkgs,
  ...
}: let
  # get devshell names from flake
  devShellNames = builtins.concatStringsSep " " (builtins.attrNames self.devShells.${pkgs.stdenv.hostPlatform.system});
in {
  programs.fish = {
    # add devshells completions to init script
    interactiveShellInit = ''
      complete -c develop -f -a "${devShellNames}"
    '';
    functions.develop = {
      description = "Easily jump into any of the ooknet devshells";
      body =
        #fish
        ''
          if test -n "$argv[1]"
            if test -n "$FLAKE"
              nix develop $FLAKE#$argv[1]
            else
              echo "error: FLAKE variable is not set";
            end
          else
            echo "error: No argument was provided";
          end
        '';
    };
  };
}
