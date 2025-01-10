{
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation {
  name = "fpp-config";
  version = "2.28";

  archiveName = "fppconfig.tar.gz";
  src = fetchzip {
    url = "https://github.com/jlambert360/FPM-AppImage/raw/refs/heads/master/config/fppconfig.tar.gz";
    sha256 = "sha256-1+dQkNuZi2LXqmUuYJHI6RYuFUmI2wzVb4D2SYdZt1Y=";
  };

  installPhase = ''
    mkdir -p $out/Binaries
    cp -rf . $out/Binaries
  '';
}
