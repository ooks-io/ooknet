{ lib, rustPlatform, fetchFromGitHub, stdenv, pkg-config, dbus, libpulseaudio, bluez }:

rustPlatform.buildRustPackage rec {
  pname = "live-buds-cli";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "JojiiOfficial";
    repo = "LiveBudsCli";
    rev = "v${version}";
    sha256 = "A4XQiJrk4ehb6+935L2JFOeAhUJ7bdukV5mL0Jxn0sQ=";

  };

  cargoSha256 = "w/dt7Q9TACw5N/+QNAKMUEngf8sAhWyGslnw3B16crQ=";  # you will need to determine this hash

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpulseaudio bluez dbus ];

  meta = with lib; {
    description = "A free cli tool to control your Galaxy buds live, Galaxy Buds+, Galaxy Buds Pro, Galaxy Buds 2 and Galaxy Buds 2 Pro";
    license = licenses.gpl3;
   #maintainers = [ maintainers.ooks-io ];  # replace with your maintainer info
    platforms = platforms.unix;
  };
}
