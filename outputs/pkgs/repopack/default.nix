{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "repopack";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "yamadashy";
    repo = "repopack";
    rev = "v${version}";
    hash = "sha256-+UcpfxMcG47j4fSOAXBvNgwKy0nSC6UKJvNc5G8c6U0=";
  };

  npmDepsHash = "sha256-Jyp48JNRuqxGSNi6eLrnOkF4Z+OResbtfbTYHg1S1mU=";

  meta = {
    description = ''
      A powerful tool that packs your entire repository into a
      single, AI-friendly file.
    '';
    homepage = "https://github.com/yamadashy/repopack";
    mainProgram = "repopack";
  };
}
