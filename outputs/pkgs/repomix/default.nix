{
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "repomix";
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "yamadashy";
    repo = "repomix";
    rev = "v${version}";
    hash = "sha256-ZfkaopnftD6wJ0KAScE1q2u3/jM36QVwx6CgPiS1nWY";
  };

  npmDepsHash = "sha256-/ocQ5vp67w5U6Gx+1LgJzcObsvKeTVN9BOEKXSb6oU0";

  meta = {
    description = ''
      A powerful tool that packs your entire repository into a
      single, AI-friendly file.
    '';
    homepage = "https://github.com/yamadashy/repomix";
    mainProgram = "repomix";
  };
}
