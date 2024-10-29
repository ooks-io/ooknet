# Credit github:seirl
# <https://github.com/seirl/seirl-nixos/blob/a10128546a5412049ce547f2f6ce6a80b3c253af/pkgs/instawow/default.nix>
{
  lib,
  python3,
  fetchFromGitHub,
  plugins ? [],
}:
python3.pkgs.buildPythonApplication rec {
  pname = "instawow";
  version = "4.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "layday";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-tk/Lugjdzufl8VPcpj7R2q81SBE/+KtS3VhsXQ2VKZM=";
  };

  extras = []; # Disable GUI, most dependencies are not packaged.

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];
  propagatedBuildInputs = with python3.pkgs;
    [
      aiohttp
      aiohttp-client-cache
      attrs
      cattrs
      click
      diskcache
      iso8601
      loguru
      packaging
      pluggy
      prompt-toolkit
      rapidfuzz
      truststore
      typing-extensions
      yarl
    ]
    ++ plugins;

  meta = with lib; {
    homepage = "https://github.com/layday/instawow";
    description = "World of Warcraft add-on manager CLI and GUI";
    mainProgram = "instawow";
    license = licenses.gpl3;
    maintainers = with maintainers; [seirl];
  };
}
