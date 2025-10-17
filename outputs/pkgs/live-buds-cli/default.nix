{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  libpulseaudio,
  bluez,
}:
rustPlatform.buildRustPackage rec {
  pname = "live-buds-cli";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "JojiiOfficial";
    repo = "LiveBudsCli";
    rev = "v${version}";
    sha256 = "A4XQiJrk4ehb6+935L2JFOeAhUJ7bdukV5mL0Jxn0sQ=";
  };

  cargoHash = "sha256-bgzd0gcY17pH+CmThEHUz75XbjzMzDdZHzzkEaCEkFU=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [libpulseaudio bluez dbus];

  meta = {
    description = "A free cli tool to control your Galaxy buds live, Galaxy Buds+, Galaxy Buds Pro, Galaxy Buds 2 and Galaxy Buds 2 Pro";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
}
