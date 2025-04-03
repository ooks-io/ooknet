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
    owner = "krisutofu";
    repo = "wii-u-gc-adapter";
    rev = "1caf1052d8d7888555a5d37e9e96f6a5c505f445";
    hash = "sha256-0V6iNnm2qcYrbZpeVcxeNtudUNOgZkV9s4ufFVmX9hc=";
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
