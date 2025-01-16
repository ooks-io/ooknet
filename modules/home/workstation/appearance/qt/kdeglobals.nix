{
  lib,
  hozen,
  ...
}: let
  inherit (hozen) color;
in {
  xdg.configFile."kdeglobals".text = lib.generators.toINI {} {
    "ColorEffects:Disabled" = {
      Color = "#${color.layout.menu}";
      ColorAmount = 0.30000000000000004;
      ColorEffect = 2;
      ContrastAmount = 0.1;
      ContrastEffect = 0;
      IntensityAmount = -1;
      IntensityEffect = 0;
    };
    "ColorEffects:Inactive" = {
      ChangeSelectionColor = true;
      Color = "#${color.layout.menu}";
      ColorAmount = 0.5;
      ColorEffect = 3;
      ContrastAmount = 0;
      ContrastEffect = 0;
      Enable = true;
      IntensityAmount = 0;
      IntensityEffect = 0;
    };
    "Colors:Button" = {
      BackgroundAlternate = "#${color.primary.base}";
      BackgroundNormal = "#${color.layout.body}";
      DecorationFocus = "#${color.primary.base}";
      DecorationHover = "#${color.layout.body}";
      ForegroundActive = "#${color.orange.base}";
      ForegroundInactive = "#${color.typography.subtext}";
      ForegroundLink = "#${color.primary.base}";
      ForegroundNegative = "#${color.error.base}";
      ForegroundNeutral = "#${color.yellow.base}";
      ForegroundNormal = "#${color.typography.text}";
      ForegroundPositive = "#${color.success.base}";
      ForegroundVisited = "#${color.purple.base}";
    };

    "Colors:Complementary" = {
      BackgroundAlternate = "#${color.neutrals."900"}";
      BackgroundNormal = "#${color.layout.dimmed}";
      DecorationFocus = "#${color.primary.base}";
      DecorationHover = "#${color.layout.body}";
      ForegroundActive = "#${color.orange.base}";
      ForegroundInactive = "#${color.typography.subtext}";
      ForegroundLink = "#${color.primary.base}";
      ForegroundNegative = "#${color.error.base}";
      ForegroundNeutral = "#${color.yellow.base}";
      ForegroundNormal = "#${color.typography.text}";
      ForegroundPositive = "#${color.success.base}";
      ForegroundVisited = "#${color.purple.base}";
    };

    "Colors:Header" = {
      BackgroundAlternate = "#${color.neutrals."900"}";
      BackgroundNormal = "#${color.layout.dimmed}";
      DecorationFocus = "#${color.primary.base}";
      DecorationHover = "#${color.layout.body}";
      ForegroundActive = "#${color.orange.base}";
      ForegroundInactive = "#${color.typography.subtext}";
      ForegroundLink = "#${color.primary.base}";
      ForegroundNegative = "#${color.error.base}";
      ForegroundNeutral = "#${color.yellow.base}";
      ForegroundNormal = "#${color.typography.text}";
      ForegroundPositive = "#${color.success.base}";
      ForegroundVisited = "#${color.purple.base}";
    };

    "Colors:Selection" = {
      BackgroundAlternate = "#${color.primary.base}";
      BackgroundNormal = "#${color.primary.base}";
      DecorationFocus = "#${color.primary.base}";
      DecorationHover = "#${color.layout.body}";
      ForegroundLink = "#${color.primary.base}";
      ForegroundInactive = "#${color.layout.dimmed}";
      ForegroundActive = "#${color.orange.base}";
      ForegroundNegative = "#${color.error.base}";
      ForegroundNeutral = "#${color.yellow.base}";
      ForegroundNormal = "#${color.neutrals."900"}";
      ForegroundPositive = "#${color.success.base}";
      ForegroundVisited = "#${color.purple.base}";
    };

    "Colors:Tooltip" = {
      BackgroundAlternate = "#${color.layout.dimmed}";
      BackgroundNormal = "#${color.layout.menu}";
      DecorationFocus = "#${color.primary.base}";
      DecorationHover = "#${color.layout.body}";
      ForegroundActive = "#${color.orange.base}";
      ForegroundInactive = "#${color.typography.subtext}";
      ForegroundLink = "#${color.primary.base}";
      ForegroundNegative = "#${color.error.base}";
      ForegroundNeutral = "#${color.yellow.base}";
      ForegroundNormal = "#${color.typography.text}";
      ForegroundPositive = "#${color.success.base}";
      ForegroundVisited = "#${color.purple.base}";
    };

    "Colors:View" = {
      BackgroundAlternate = "#${color.layout.dimmed}";
      BackgroundNormal = "#${color.layout.menu}";
      DecorationFocus = "#${color.primary.base}";
      DecorationHover = "#${color.layout.body}";
      ForegroundActive = "#${color.orange.base}";
      ForegroundInactive = "#${color.typography.subtext}";
      ForegroundLink = "#${color.primary.base}";
      ForegroundNegative = "#${color.error.base}";
      ForegroundNeutral = "#${color.yellow.base}";
      ForegroundNormal = "#${color.typography.text}";
      ForegroundPositive = "#${color.success.base}";
      ForegroundVisited = "#${color.purple.base}";
    };

    "Colors:Window" = {
      BackgroundAlternate = "#${color.neutrals."900"}";
      BackgroundNormal = "#${color.layout.dimmed}";
      DecorationFocus = "#${color.primary.base}";
      DecorationHover = "#${color.layout.body}";
      ForegroundActive = "#${color.orange.base}";
      ForegroundInactive = "#${color.typography.subtext}";
      ForegroundLink = "#${color.primary.base}";
      ForegroundNegative = "#${color.error.base}";
      ForegroundNeutral = "#${color.yellow.base}";
      ForegroundNormal = "#${color.typography.text}";
      ForegroundPositive = "#${color.success.base}";
      ForegroundVisited = "#${color.purple.base}";
    };

    General = {
      ColorScheme = "GruvboxMaterial";
      Name = "GruvboxMaterial";
      accentActiveTitlebar = false;
      shadeSortColumn = true;
    };

    KDE = {
      contrast = 4;
    };

    WM = {
      activeBackground = "#${color.layout.menu}";
      activeBlend = "#${color.typography.text}";
      activeForeground = "#${color.typography.text}";
      inactiveBackground = "#${color.neutrals."900"}";
      inactiveBlend = "#${color.typography.subtext}";
      inactiveForeground = "#${color.typography.subtext}";
    };
  };
}
