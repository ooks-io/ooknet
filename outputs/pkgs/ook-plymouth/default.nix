{
  stdenvNoCC,
  imagemagick,
  ook,
  fontFamily ? "monospace",
  # the throbber is the ooknet.org favicon glyph, rendered from this font
  fontPackage ? null,
}: let
  c = ook.themes.dark;
  bg = c.layout.body;
in
  stdenvNoCC.mkDerivation {
    pname = "ook-plymouth";
    version = "0.1";

    dontUnpack = true;
    nativeBuildInputs = [imagemagick];

    # all assets are drawn from the palette at build time so the password box
    # matches hyprlock (200x30, 2px border) and nothing needs hand-made pngs
    buildPhase = ''
      mkdir theme
      font=$(find ${toString fontPackage} -name '*Bold.ttf' 2>/dev/null | sort | head -1)
      [ -n "$font" ] || font=DejaVu-Sans-Mono-Bold

      # [0] breathing between 35% and 100%, two-step plays 30 frames a second
      # so 60 frames is a 2s cycle
      # label:@file, a literal [0] would be read as a frame index
      printf "[0]" > glyph.txt
      magick -background none -fill "#${c.yellow.base}" -font "$font" -pointsize 40 label:@glyph.txt -trim +repage glyph.png
      for i in $(seq 0 59); do
        pct=$(awk -v i=$i 'BEGIN { printf "%d", 67.5 - 32.5 * cos(i / 60 * 2 * 3.14159265) }')
        magick glyph.png -channel A -evaluate multiply "$(awk -v p=$pct 'BEGIN { print p / 100 }')" +channel theme/throbber-$(printf %02d $i).png
      done

      magick -size 200x30 "xc:#${c.secondary.base}" -fill "#${c.layout.menu}" -draw "rectangle 2,2 197,27" theme/entry.png
      # 8px square with 4px of air on the right, bullets are laid out by image width
      magick -size 12x8 xc:none -fill "#${c.typography.text}" -draw "rectangle 0,0 7,7" theme/bullet.png
      for f in lock capslock keyboard; do
        magick -size 1x1 xc:none theme/$f.png
      done

      cat > theme/ook.plymouth <<PLY
      [Plymouth Theme]
      Name=ook
      Description=ooknet minimal
      ModuleName=two-step

      [two-step]
      Font=${fontFamily} 12
      TitleFont=${fontFamily} 16
      ImageDir=$out/share/plymouth/themes/ook
      DialogHorizontalAlignment=.5
      DialogVerticalAlignment=.5
      TitleHorizontalAlignment=.5
      TitleVerticalAlignment=.5
      HorizontalAlignment=.5
      VerticalAlignment=.5
      Transition=none
      TransitionDuration=0.0
      BackgroundStartColor=0x${bg}
      BackgroundEndColor=0x${bg}
      UseProgressBar=false
      MessageBelowAnimation=true

      [boot-up]
      UseEndAnimation=false

      [shutdown]
      UseEndAnimation=false

      [reboot]
      UseEndAnimation=false
      PLY
      sed -i 's/^      //' theme/ook.plymouth
    '';

    installPhase = ''
      mkdir -p $out/share/plymouth/themes
      cp -r theme $out/share/plymouth/themes/ook
    '';
  }
