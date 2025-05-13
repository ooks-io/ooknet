{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  make-disk-image = import "${inputs.nixpkgs}/nixos/lib/make-disk-image.nix";
in {
  system.build.image = make-disk-image {
    inherit lib pkgs config;
    partitionTableType = "none";
    name = "linode-image";
    format = "raw";
    # Linode requires the image to be gzip'd
    # unzipped image cannot exceed 6gb
    postVM = ''
      ${pkgs.gzip}/bin/gzip -6 -c -- $diskImage > \
      $out/nixos-image-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.img.gz
      rm $diskImage
    '';
  };
}
