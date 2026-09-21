{lib}: let
  inherit (lib) concatStringsSep mapAttrsToList flatten concatMap;

  # overrides the whole UI palette. nearly everything in forgejos theme
  # references --steel-* so redefining those cascades to body/box/text/etc
  toForgejoTheme = {
    scheme,
    base ? "forgejo-dark",
  }: let
    inherit (scheme) neutrals primary;
    v = name: hex: "  --${name}: #${hex};";
    ref = name: target: "  --${name}: var(--${target});";

    # forgejos neutral ramp (900 darkest -> 100 lightest), 1:1 with ook neutrals
    steelKeys = ["900" "850" "800" "750" "700" "650" "600" "550" "500" "450" "400" "350" "300" "250" "200" "150" "100"];
    steel = map (k: v "steel-${k}" neutrals.${k}) steelKeys;

    # dark theme: primary-dark-N is lighter (hard), primary-light-N is darker (soft)
    alphas = [
      {
        p = "10";
        h = "19";
      }
      {
        p = "20";
        h = "33";
      }
      {
        p = "30";
        h = "4b";
      }
      {
        p = "40";
        h = "66";
      }
      {
        p = "50";
        h = "80";
      }
      {
        p = "60";
        h = "99";
      }
      {
        p = "70";
        h = "b3";
      }
      {
        p = "80";
        h = "cc";
      }
      {
        p = "90";
        h = "e1";
      }
    ];
    primaryVars =
      [
        (v "color-primary" primary.base)
        (ref "color-primary-contrast" "steel-900")
        (v "color-primary-dark-1" primary.hard1)
        (v "color-primary-dark-2" primary.hard1)
        (v "color-primary-dark-3" primary.hard2)
        (v "color-primary-dark-4" primary.hard2)
        (v "color-primary-dark-5" primary.hard3)
        (v "color-primary-dark-6" primary.hard3)
        (v "color-primary-dark-7" primary.hard4)
        (v "color-primary-light-1" primary.soft1)
        (v "color-primary-light-2" primary.soft2)
        (v "color-primary-light-3" primary.soft3)
        (v "color-primary-light-4" primary.soft4)
        (v "color-primary-light-5" primary.soft4)
        (v "color-primary-light-6" primary.soft4)
        (v "color-primary-light-7" primary.soft4)
        (ref "color-primary-hover" "color-primary-light-1")
        (ref "color-primary-active" "color-primary-light-2")
      ]
      ++ (map (a: v "color-primary-alpha-${a.p}" "${primary.base}${a.h}") alphas);

    named = ["red" "orange" "yellow" "olive" "green" "teal" "blue" "violet" "purple" "pink" "brown"];
    namedVars =
      (concatMap (n: let
          s = scheme.${n};
        in [
          (v "color-${n}" s.base)
          (v "color-${n}-light" s.hard1)
          (v "color-${n}-dark-1" s.soft1)
          (v "color-${n}-dark-2" s.soft2)
        ])
        named)
      ++ [
        (ref "color-grey" "steel-500")
        (ref "color-grey-light" "steel-300")
        (ref "color-black" "steel-900")
        (ref "color-black-light" "steel-850")
      ];

    badgeVars = concatMap (n: let
      b = scheme.${n}.base;
    in [
      (v "color-${n}-badge" b)
      (v "color-${n}-badge-bg" "${b}22")
      (v "color-${n}-badge-hover-bg" "${b}44")
    ]) ["red" "green" "yellow" "orange"];

    consoleVars = [
      (ref "color-console-fg" "steel-100")
      (ref "color-console-fg-subtle" "steel-300")
      (ref "color-console-bg" "steel-850")
      (ref "color-console-border" "steel-700")
      "  --color-console-hover-bg: #ffffff16;"
      (ref "color-console-active-bg" "steel-650")
      (ref "color-console-menu-bg" "steel-700")
      (ref "color-console-menu-border" "steel-550")
      (ref "color-ansi-black" "steel-800")
      (v "color-ansi-red" scheme.red.base)
      (v "color-ansi-green" scheme.green.base)
      (v "color-ansi-yellow" scheme.yellow.base)
      (v "color-ansi-blue" scheme.blue.base)
      (v "color-ansi-magenta" scheme.purple.base)
      (v "color-ansi-cyan" scheme.teal.base)
      (ref "color-ansi-white" "steel-200")
      (ref "color-ansi-bright-black" "steel-500")
      (v "color-ansi-bright-red" scheme.red.hard1)
      (v "color-ansi-bright-green" scheme.green.hard1)
      (v "color-ansi-bright-yellow" scheme.yellow.hard1)
      (v "color-ansi-bright-blue" scheme.blue.hard1)
      (v "color-ansi-bright-magenta" scheme.purple.hard1)
      (v "color-ansi-bright-cyan" scheme.teal.hard1)
      (ref "color-ansi-bright-white" "steel-100")
    ];

    # syntax highlighting (chroma). forgejo ships these as hardcoded
    # `.chroma .X { color }` rules; we re-emit them from the semantic
    # syntax palette (gruvbox-material assignments). class -> token type
    # per https://github.com/alecthomas/chroma types.go
    syn = scheme.syntax;
    hx = h: "#${h}";
    text = "var(--color-text)";
    crule = class: color: "  .chroma .${class} { color: ${color}; }";
    chromaRules = [
      (crule "k" (hx syn.statement)) # keyword
      (crule "kc" (hx syn.boolean)) # keyword constant
      (crule "kd" (hx syn.storageClass)) # keyword declaration
      (crule "kn" (hx syn.include)) # keyword namespace
      (crule "kp" (hx syn.statement)) # keyword pseudo
      (crule "kr" (hx syn.statement)) # keyword reserved
      (crule "kt" (hx syn.type)) # keyword type
      (crule "n" text) # name
      (crule "na" (hx syn.identifier)) # name attribute
      (crule "nb" (hx syn.function)) # name builtin
      (crule "bp" (hx syn.function)) # name builtin pseudo
      (crule "nc" (hx syn.type)) # name class
      (crule "nd" (hx syn.macro)) # name decorator
      (crule "ne" (hx syn.exception)) # name exception
      (crule "nf" (hx syn.function)) # name function
      (crule "fm" (hx syn.function)) # name function magic
      (crule "ni" (hx syn.special)) # name entity
      (crule "nl" (hx syn.label)) # name label
      (crule "nn" text) # name namespace
      (crule "no" (hx syn.constant)) # name constant
      (crule "nt" (hx syn.tag)) # name tag
      (crule "nv" (hx syn.identifier)) # name variable
      (crule "vc" (hx syn.identifier)) # name variable class
      (crule "vg" (hx syn.identifier)) # name variable global
      (crule "vi" (hx syn.identifier)) # name variable instance
      (crule "nx" text) # name other
      (crule "s" (hx syn.string)) # string
      (crule "s1" (hx syn.string)) # string single
      (crule "s2" (hx syn.string)) # string double
      (crule "sb" (hx syn.string)) # string backtick
      (crule "sc" (hx syn.string)) # string char
      (crule "sd" (hx syn.string)) # string doc
      (crule "sh" (hx syn.string)) # string heredoc
      (crule "sx" (hx syn.string)) # string other
      (crule "sa" (hx syn.storageClass)) # string affix
      (crule "dl" (hx syn.string)) # string delimiter
      (crule "se" (hx syn.specialChar)) # string escape
      (crule "ss" (hx syn.specialChar)) # string symbol
      (crule "si" (hx syn.special)) # string interpol
      (crule "sr" (hx syn.special)) # string regex
      (crule "m" (hx syn.number)) # number
      (crule "mb" (hx syn.number)) # number bin
      (crule "mf" (hx syn.number)) # number float
      (crule "mh" (hx syn.number)) # number hex
      (crule "mi" (hx syn.number)) # number int
      (crule "mo" (hx syn.number)) # number oct
      (crule "il" (hx syn.number)) # number int long
      (crule "o" (hx syn.operator)) # operator
      (crule "ow" (hx syn.statement)) # operator word
      (crule "p" text) # punctuation
      (crule "c" (hx syn.comment)) # comment
      (crule "c1" (hx syn.comment)) # comment single
      (crule "ch" (hx syn.comment)) # comment hashbang
      (crule "cm" (hx syn.comment)) # comment multiline
      (crule "cs" (hx syn.comment)) # comment special
      (crule "cp" (hx syn.preproc)) # comment preproc
      (crule "cpf" (hx syn.preproc)) # comment preproc file
      (crule "go" (hx syn.comment)) # generic output
      (crule "gp" (hx syn.comment)) # generic prompt
      (crule "gh" (hx syn.identifier)) # generic heading
      (crule "gu" (hx syn.identifier)) # generic subheading
      (crule "ge" (hx syn.identifier)) # generic emph
      (crule "gs" text) # generic strong
      (crule "gr" (hx syn.exception)) # generic error
      (crule "gt" (hx syn.exception)) # generic traceback
      (crule "gd" (hx syn.exception)) # generic deleted (bg kept from base)
      (crule "gi" (hx syn.function)) # generic inserted (bg kept from base)
      (crule "w" (hx syn.comment)) # whitespace
    ];

    lines = flatten [
      "/* ooknet generated forgejo theme: ${scheme.slug} */"
      "@import url(\"theme-${base}.css\");"
      ""
      ":root {"
      "  --is-dark-theme: true;"
      ""
      "  /* neutrals */"
      steel
      ""
      "  /* primary */"
      primaryVars
      ""
      "  /* named colors */"
      namedVars
      ""
      "  /* badges */"
      badgeVars
      ""
      "  /* console + ansi */"
      consoleVars
      ""
      "  color-scheme: dark;"
      "  accent-color: var(--color-accent);"
      "}"
      ""
      "/* syntax highlighting (chroma) */"
      chromaRules
    ];
  in
    concatStringsSep "\n" lines;
in {
  inherit toForgejoTheme;
}
