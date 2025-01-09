{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  udev,
}:
stdenv.mkDerivation {
  pname = "wii-u-gc-adapter";
  version = "unstable-2020-01-20";

  src = fetchFromGitHub {
    owner = "ToadKing";
    repo = "wii-u-gc-adapter";
    rev = "fa098efa7f6b34f8cd82e2c249c81c629901976c";
    hash = "sha256-wm0vDU7QckFvpgI50PG4/elgPEkfr8xTmroz8kE6QMo";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
    udev
  ];

  # Add -Wformat to CFLAGS to enable format checks
  NIX_CFLAGS_COMPILE = "-Wformat";

  # Disable hardening to prevent format security errors
  hardeningDisable = ["format"];

  makeFlags = ["PREFIX=${placeholder "out"}"];

  # Add install phase since Makefile doesn't have one
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp wii-u-gc-adapter $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool for using the Wii U GameCube Adapter on Linux";
    homepage = "https://github.com/ToadKing/wii-u-gc-adapter";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
