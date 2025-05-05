{
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "repomix";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "yamadashy";
    repo = "repomix";
    rev = "v${version}";
    hash = "sha256-VVTI9dmSHVsXttDPoxRkPYVC8VU/678spLlyoyZGvpI=";
  };

  npmDepsHash = "sha256-VY2YjpOKimgX90ieu4jjZ6YVJYQqq3l3k/iDfsTMZmI=";

  meta = {
    description = ''
      A powerful tool that packs your entire repository into a
      single, AI-friendly file.
    '';
    homepage = "https://github.com/yamadashy/repomix";
    mainProgram = "repomix";
  };
}
