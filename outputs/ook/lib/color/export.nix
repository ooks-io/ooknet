{lib}: let
  inherit (lib) concatStringsSep mapAttrsToList flatten;

  # Convert a flat color to CSS custom property
  colorToCss = name: value: "  --ooknet-${name}: #${value};";

  # Convert a color scale to CSS custom properties
  scaleToCss = prefix: scale:
    mapAttrsToList (variant: color: colorToCss "${prefix}-${variant}" color) scale;

  # Convert neutrals to CSS custom properties
  neutralsToCss = neutrals:
    mapAttrsToList (weight: color: colorToCss "neutral-${weight}" color) neutrals;

  # Convert alert colors to CSS custom properties
  alertToCss = name: alert: [
    (colorToCss "${name}-fg" alert.fg)
    (colorToCss "${name}-bg" alert.bg)
    (colorToCss "${name}-border" alert.border)
    (colorToCss "${name}-base" alert.base)
  ];

  # Convert semantic colors to CSS custom properties
  semanticToCss = {layout, border, typography}: let
    layoutVars = mapAttrsToList (key: color: colorToCss "layout-${key}" color) layout;
    borderVars = mapAttrsToList (key: color: colorToCss "border-${key}" color) border;
    typographyVars = mapAttrsToList (key: color: colorToCss "typography-${key}" color) typography;
  in
    layoutVars ++ borderVars ++ typographyVars;

  # Convert syntax colors to CSS custom properties
  syntaxToCss = syntax:
    mapAttrsToList (key: color: colorToCss "syntax-${key}" color) syntax;

  # Main function to convert color scheme to CSS
  toScss = scheme: let
    header = [
      "/* Generated color scheme: ${scheme.slug} */"
      ":root {"
    ];

    # Neutrals section
    neutralsSection = [
      ""
      "  /* Neutrals */"
    ] ++ (neutralsToCss scheme.neutrals);

    # Named colors section
    namedColors = ["red" "orange" "yellow" "olive" "green" "teal" "blue" "violet" "purple" "pink" "brown" "primary"];
    namedColorsSection = [
      ""
      "  /* Named colors */"
    ] ++ (flatten (map (color: scaleToCss color scheme.${color}) namedColors));

    # Secondary section
    secondarySection = [
      ""
      "  /* Secondary */"
    ] ++ (scaleToCss "secondary" scheme.secondary);

    # Alert section
    alertSection = [
      ""
      "  /* Alerts */"
    ] ++ (flatten [
      (alertToCss "error" scheme.error)
      (alertToCss "warning" scheme.warning)
      (alertToCss "success" scheme.success)
      (alertToCss "note" scheme.note)
      (alertToCss "tip" scheme.tip)
    ]);

    # Semantic section
    semanticSection = [
      ""
      "  /* Semantic */"
    ] ++ (semanticToCss {
      inherit (scheme) layout border typography;
    });

    # Syntax section
    syntaxSection = [
      ""
      "  /* Syntax */"
    ] ++ (syntaxToCss scheme.syntax);

    # Base16 section
    base16Section = [
      ""
      "  /* Base16 */"
      (colorToCss "base00" scheme.base00)
      (colorToCss "base01" scheme.base01)
      (colorToCss "base02" scheme.base02)
      (colorToCss "base03" scheme.base03)
      (colorToCss "base04" scheme.base04)
      (colorToCss "base05" scheme.base05)
      (colorToCss "base06" scheme.base06)
      (colorToCss "base07" scheme.base07)
      (colorToCss "base08" scheme.base08)
      (colorToCss "base09" scheme.base09)
      (colorToCss "base0A" scheme.base0A)
      (colorToCss "base0B" scheme.base0B)
      (colorToCss "base0C" scheme.base0C)
      (colorToCss "base0D" scheme.base0D)
      (colorToCss "base0E" scheme.base0E)
      (colorToCss "base0F" scheme.base0F)
      (colorToCss "base10" scheme.base10)
      (colorToCss "base11" scheme.base11)
      (colorToCss "base12" scheme.base12)
      (colorToCss "base13" scheme.base13)
      (colorToCss "base14" scheme.base14)
      (colorToCss "base15" scheme.base15)
      (colorToCss "base16" scheme.base16)
      (colorToCss "base17" scheme.base17)
    ];

    footer = [
      "}"
    ];

    allSections = flatten [
      header
      neutralsSection
      namedColorsSection
      secondarySection
      alertSection
      semanticSection
      syntaxSection
      base16Section
      footer
    ];
  in
    concatStringsSep "\n" allSections;
in {
  inherit toScss;
}
