{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  version = "1.0.0";
in
  buildGoModule {
    pname = "goki";
    inherit version;

    src = fetchFromGitHub {
      owner = "abeleinin";
      repo = "goki";
      rev = "66de71a5e559d3a53ebaeff51aa05eefc22e7431";
      hash = "sha256-4RJ5APJF/Dr/gNKS4Oz0uxsqCKNAwYzni73X6hdu8+A=";
    };

    ldflags = ["-s" "-w"];

    vendorHash = "sha256-SCX/eXXnwnCNZ11jw+ZNeJ42HUhI5MnV+AaO89BTKJs=";
  }
