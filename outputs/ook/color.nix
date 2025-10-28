{ook-lib, ...}: let
  inherit (ook-lib.color.utils) mkLightColorScheme mkDarkColorScheme;

  darkScheme = mkDarkColorScheme {
    slug = "gruvbox-material-dark-medium";
    neutrals = {
      "50" = "dfd2b3";
      "100" = "d9c7a5";
      "150" = "d4be98";
      "200" = "c6b395";
      "250" = "b4a288";
      "300" = "a49384";
      "350" = "99897a";
      "400" = "8b7c6f";
      "450" = "7d6f64";
      "500" = "716860";
      "550" = "645f59";
      "600" = "585350";
      "650" = "4d4947";
      "700" = "3f3b3b";
      "750" = "32302f";
      "800" = "282828";
      "850" = "212121";
      "900" = "1a1a1a";
    };
    primary = "a9b665";
    red = "ea6962";
    orange = "e78a4e";
    yellow = "d8a657";
    olive = "b9b25f";
    green = "a9b665";
    teal = "89b482";
    blue = "7daea3";
    violet = "d892c1";
    purple = "d3869b";
    pink = "cf91be";
    brown = "a87757";
  };

  lightScheme = mkLightColorScheme {
    slug = "gruvbox-material-light-soft";
    neutrals = {
      "50" = "f7efda";
      "100" = "f4eac8";
      "150" = "f2e5bc";
      "200" = "e7d9b1";
      "250" = "ddcca6";
      "300" = "d3c19c";
      "350" = "c5b496";
      "400" = "b7a78f";
      "450" = "a89984";
      "500" = "a08e79";
      "550" = "9a826a";
      "600" = "91785f";
      "650" = "8a7056";
      "700" = "745a44";
      "750" = "6d4e3c";
      "800" = "654735";
      "850" = "5e4131";
      "900" = "51372a";
    };
    primary = "45707a";
    red = "be4141"; # contrast 4.55
    orange = "ad540b"; # contrast 4.52
    yellow = "966208"; # contrast 4.51
    olive = "707029"; # contrast 4.51
    green = "67732b"; # contrast 4.51
    teal = "497459"; # contrast 4.67
    blue = "45707a"; # contrast 4.75
    violet = "7d6198"; # contrast 4.54
    purple = "8f5b7c"; # contrast 4.63
    pink = "925d66"; # contrast 4.6
    brown = "654735"; # contrast 7.31
  };
in {
  color = darkScheme;
  themes = {
    dark = darkScheme;
    light = lightScheme;
  };
}
