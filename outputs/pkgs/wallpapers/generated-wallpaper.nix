{
  pkgs,
  config,
}: let
  inherit (config.ooknet.hardware) monitors;
  inherit (config.ooknet.appearance) colorscheme;
  largest = f: xs: builtins.head (builtins.sort (a: b: a > b) (map f xs));
  largestWidth = largest (x: x.width) monitors;
  largestHeight = largest (x: x.height) monitors;
in
  {
    width ? largestWidth,
    height ? largestHeight,
  }:
  # Credit to misterio77
    pkgs.stdenv.mkDerivation {
      name = "generated-nix-wallpaper-${colorscheme.slug}.png";
      src = pkgs.writeTextFile {
        name = "template.svg";
        text = ''
                <svg width="431.57" height="329.62" viewBox="0 0 114.19 87.21" xml:space="preserve" xmlns="http://www.w3.org/2000/svg">
            <g style="display:inline">
              <g style="mix-blend-mode:normal">
                <g style="fill:#282828;fill-opacity:1">
                  <path style="display:inline;mix-blend-mode:normal;fill:#282828;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:.444423" d="M116.06 94.24c-.27 0-.45.03-.45.03s.69.13 1.05.61c-.71-.25-1.42-.13-1.42-.13s1.27.23 1.26 1.27c-.01.63 1.17-.05 1.17-.05s0-.12-.05-.28l.42-.2s.04-.69-.99-1.08a2.87 2.87 0 0 0-.99-.17z" transform="matrix(4.28084 0 0 5.59645 -460.15 -527.4)"/>
                  <path style="display:inline;mix-blend-mode:normal;fill:#282828;fill-opacity:1;stroke-width:.256154" d="m109.94 95.95-.1 1.2a2.05 2.05 87.28 0 0 .03.52l.12.66a.27.27 124.27 0 1-.21.32l-2.12.42a.22.22 117.74 0 0-.15.3l1.35 3.17a.5.5 38.9 0 0 .37.3l2.45.47a.84.84 28.38 0 1 .44.24l.53.54a.67.67 67.44 0 1 .2.46l.07 5a.27.27 44.53 0 0 .27.27h14.95a.26.26 134.21 0 0 .26-.26l-.14-5.24a.63.63 111.14 0 1 .17-.45l1.06-1.1a.83.83 151.46 0 1 .44-.24l2.5-.48a.5.5 141.1 0 0 .36-.3l1.36-3.17a.22.22 62.59 0 0-.16-.3l-1.87-.4a.21.21 63.32 0 1-.15-.3.63.63 90.38 0 0 0-.29l-.04-.96a.48.48 46.47 0 0-.44-.46l-9.33-.87a15.44 15.44.54 0 0-2.57-.02l-9.36.69a.3.3 135.21 0 0-.29.28z" transform="matrix(4.28084 0 0 5.59645 -460.15 -527.4)"/>
                </g>
                <g style="display:inline;mix-blend-mode:normal">
                  <path style="display:inline;mix-blend-mode:normal;fill:#4d4947;stroke-width:.264583" d="m110.68 97.3 20.2-.1a.18.18 56.04 0 1 .16.25l-1.75 4.24a.45.45 142.82 0 1-.36.27l-2.81.33a.48.48 144.4 0 0-.38.27l-1.02 2.13a.42.42 147.77 0 1-.38.24h-7.73a.4.4 33.78 0 1-.36-.24l-.86-2.09a.45.45 37.37 0 0-.37-.27l-2.87-.36a.41.41 39.75 0 1-.34-.29l-1.31-4.12a.2.2 126.01 0 1 .18-.25z" transform="matrix(4.28084 0 0 5.59645 -460.15 -527.4)"/>
                </g>
                <path style="display:inline;mix-blend-mode:normal;fill:#645f59;fill-opacity:1;stroke-width:.198148" d="M115.76 112.69h9.05a.16.16 121 0 0 .14-.24l-1.19-2.23a.44.44 30.98 0 0-.39-.23h-6.28a.43.43 148.1 0 0-.38.24l-1.1 2.22a.16.16 58.13 0 0 .15.24z" transform="matrix(4.28084 0 0 5.59645 -459.03 -568.85)"/>
                <path style="mix-blend-mode:normal;fill:#585350;fill-opacity:1;stroke-width:.264583" d="m115.16 112.77 10.25-.8a.19.19 50.11 0 1 .2.23l-.78 2.96a.34.34 142.61 0 1-.33.26l-7.73-.07a.48.48 29.14 0 1-.4-.23l-1.33-2.1a.16.16 116.64 0 1 .12-.25z" transform="matrix(4.28084 0 0 5.59645 -459.03 -568.85)"/>
                <path style="fill:#4d4947;stroke-width:.282971" d="m115.07 112.8.54-.35 8.98-.76.9.28z" transform="matrix(4.28084 0 0 5.59645 -459.03 -568.85)"/>
                <g style="display:inline">
                  <g transform="matrix(16.73121 0 0 21.58701 1366.5 -2391.45)">
                    <path style="fill:#3f3b3b;stroke-width:.0988898" d="M-79.25 112.29c0 .23-.18.56-.41.56-.23 0-.42-.33-.42-.56 0-.23.19-.34.42-.34.23 0 .41.1.41.34z"/>
                    <ellipse style="fill:#282828;stroke:none;stroke-width:.0988898" cx="-79.66" cy="112.29" rx=".42" ry=".41"/>
                    <circle style="display:inline;mix-blend-mode:normal;fill:#a49384;stroke:none;stroke-width:.314514" cx="114.61" cy="99.25" transform="matrix(.25586 0 0 .25925 -109.18 86.35)" r=".2"/>
                  </g>
                  <g transform="matrix(16.73121 0 0 21.58701 1410.9 -2390.86)">
                    <path style="fill:#3f3b3b;stroke-width:.0988898" d="M-79.25 112.29c0 .23-.18.53-.41.53-.23 0-.42-.3-.42-.53 0-.23.19-.34.42-.34.23 0 .41.11.41.34z"/>
                    <ellipse style="fill:#282828;stroke:none;stroke-width:.0988898" cx="-79.66" cy="112.29" rx=".42" ry=".41"/>
                    <circle style="display:inline;mix-blend-mode:normal;fill:#a49384;stroke:none;stroke-width:.314514" cx="124.88" cy="99.25" transform="matrix(.25586 0 0 .25925 -111.83 86.32)" r=".2"/>
                  </g>
                </g>
                <g style="fill:#585350">
                  <path style="fill:#645f59;fill-opacity:1;stroke-width:.248229" d="m118.5 97.85-.53 4.64a1.02 1.02 81.96 0 0 .07.51.32.32 23.84 0 0 .33.14h1.05a279.79 279.79.05 0 0 .53 0h1.17a257.86 257.86 179.94 0 0 .53 0h.94a.35.35 142.83 0 0 .33-.25 1.32 1.32 94.42 0 0 .04-.46l-.34-4.58 10.02-.62a.26.26 130.77 0 0 .24-.28l-.06-.63a.27.27 40.65 0 0-.28-.25l-11.62.77a121.06 121.06 0 0 1-11.77-.61.23.23 0 0 0-.25.23l.04.92a.28.28 44.47 0 0 .27.27z" transform="matrix(4.28084 0 0 5.93645 -460.22 -559.93)"/>
                  <path style="display:inline;mix-blend-mode:normal;fill:#3f3b3b;stroke-width:.282971" d="m132.36 104.73-1.68.34-8.32.51-.02-.2zm-23.43.44 1.06.1 8.2.3.03-.18z" transform="matrix(4.28084 0 0 5.59645 -459.03 -568.85)"/>
                  <path style="display:inline;mix-blend-mode:normal;fill:#32302f;stroke-width:.239324" d="m121.97 103.46.07-.17a.2.2 147.3 0 1 .19-.12h.83a.09.09 55.86 0 1 .08.12l-.07.17a.2.2 145.87 0 1-.18.12h-.85a.08.08 57.3 0 1-.07-.12z" transform="matrix(4.28084 0 0 5.59645 -460.15 -527.4)"/>
                  <path style="display:inline;mix-blend-mode:normal;fill:#32302f;stroke-width:.238198" d="m118.84 103.46-.08-.17a.2.2 32.8 0 0-.18-.12h-.82a.09.09 124.23 0 0-.08.12l.06.17a.2.2 34.22 0 0 .18.12h.84a.09.09 122.8 0 0 .08-.12z" transform="matrix(4.28084 0 0 5.59645 -460.15 -527.4)"/>
                </g>
                <path style="display:inline;mix-blend-mode:normal;fill:#585350;stroke-width:.181205" d="m131.74 98.73.82.18a.11.11 62.29 0 1 .08.16l-.68 1.66a.24.24 141 0 1-.18.15l-.83.15a.08.08 49.37 0 1-.1-.1l.72-2.1a.15.15 150.65 0 1 .17-.1z" transform="matrix(4.28084 0 0 5.59645 -460.15 -527.4)"/>
                <path style="display:inline;mix-blend-mode:normal;fill:#585350;stroke-width:.191461" d="m110.07 99.52-1.03.14a.1.1 117.92 0 0-.07.14l.76 1.53a.21.21 32 0 0 .19.12h.81a.1.1 125.81 0 0 .1-.12l-.58-1.7a.16.16 31.73 0 0-.18-.1z" transform="matrix(4.28084 0 0 5.59645 -460.15 -527.4)"/>
              </g>
            </g>
          </svg>

        '';
      };
      buildInputs = [pkgs.inkscape];
      unpackPhase = "true";
      buildPhase = ''
        inkscape --export-type="png" $src -w ${toString width} -h ${toString height} -o wallpaper.png
      '';
      installPhase = "install -Dm0644 wallpaper.png $out";
    }
