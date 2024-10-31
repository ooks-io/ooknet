{
  stdenvNoCC,
  zola,
}:
stdenvNoCC.mkDerivation {
  pname = "ooknet.org";
  version = "0.1.0";
  src = ./src;
  nativeBuildInputs = [zola];

  buildPhase = "zola build -o $out";
  dontInstall = true;
}
