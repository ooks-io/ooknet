{
  fetchFromGitHub,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "ghostty-shaders";
  src = fetchFromGitHub {
    owner = "m-ahdal";
    repo = "ghostty-shaders";
    rev = "ec29c83d81ebe7e9ca9250b3c799a2d700c1cca8";
    sha256 = "sha256-8D0H13JzCTzgzjzjERQG8ruayeHn1CPcRsd+KtC6nj4=";
  };
  installPhase = ''
    mkdir -p $out
    mv *.glsl $out
  '';
}
