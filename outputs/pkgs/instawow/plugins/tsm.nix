# Credit github:seirl
# <https://github.com/seirl/seirl-nixos/blob/a10128546a5412049ce547f2f6ce6a80b3c253af/pkgs/instawow/plugins/tsm.nix>
{
  lib,
  python3,
  fetchFromGitHub,
  instawow,
}: let
  inherit (builtins) attrValues;
in
  python3.pkgs.buildPythonPackage rec {
    pname = "instawow-tsm";
    version = "72edf2ba3850eaaa5041d5aa1f55166aeee81409";

    src = fetchFromGitHub {
      owner = "seirl";
      repo = "instawow-tsm";
      rev = version;
      sha256 = "sha256-+ojxVwPOfy3/3/raROEDS5pWCONAiALCdg7li+K6ZjI=";
    };

    pythonRemoveDeps = [
      "instawow" # Reverse the dependency
    ];
    doCheck = false; # tests require dependencies

    nativeBuildInputs = [python3.pkgs.setuptools];
    propagatedBuildInputs = attrValues {
      inherit
        (python3.pkgs)
        aiohttp
        click
        loguru
        ;
    };

    meta = with lib; {
      homepage = "https://github.com/seirl/instawow-tsm";
      description = "Instawow plugin for TradeSkillMaster";
      license = lib.licenses.gpl3;
      maintainers = with maintainers; [seirl];
    };
  }
