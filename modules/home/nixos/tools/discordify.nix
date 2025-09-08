{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  discordify = pkgs.writeShellApplication {
    name = "discordify";
    runtimeInputs = [pkgs.ffmpeg pkgs.bc pkgs.gum];
    text =
      # bash
      ''
        TARGET_SIZE_MB=15
        OUTPUT_SUFFIX="_compressed"
        AUDIO_BITRATE="128k"
        verbose=""

        log() {
          local type="$1"
          local message="$2"
          if [ "$type" = "verbose" ]; then
            if [ -n "$verbose" ]; then
              gum log --structured --level debug "$message"
            fi
            return
          fi
          if [ "$type" = "abort" ]; then
            gum log --structured --level error "$message"
            exit 1
          else
            gum log --structured --level "$type" "$message"
          fi
        }

        show_usage() {
            echo "Usage: $0 <input_video> [target_size_mb] [output_name]"
            echo ""
            echo "Examples:"
            echo "  $0 video.mp4                    # Compress to 15MB"
            echo "  $0 video.mp4 25                 # Compress to 25MB"
            echo "  $0 video.mp4 15 my_video.mp4    # Compress to 15MB with custom name"
            echo ""
            echo "Options:"
            echo "  target_size_mb: Target file size in MB (default: 15)"
            echo "  output_name: Custom output filename (default: input_compressed.mp4)"
            echo "  -v, --verbose: Show debug output"
        }

        # parse verbose flag
        while [[ $# -gt 0 ]]; do
          case $1 in
            -v|--verbose)
              verbose="true"
              shift
              ;;
            *)
              break
              ;;
          esac
        done

        # check arguments
        if [ $# -lt 1 ]; then
            show_usage
            exit 1
        fi

        INPUT_FILE="$1"

        # check if input file exists
        if [ ! -f "$INPUT_FILE" ]; then
            log "abort" "Input file '$INPUT_FILE' not found"
        fi

        # parse arguments
        if [ $# -ge 2 ]; then
            TARGET_SIZE_MB="$2"
        fi

        if [ $# -ge 3 ]; then
            OUTPUT_FILE="$3"
        else
            # Generate output filename - using different variable names to avoid nix interpolation
            input_filename=$(basename "$INPUT_FILE")
            file_extension="''${input_filename##*.}"
            file_name="''${input_filename%.*}"
            OUTPUT_FILE="''${file_name}''${OUTPUT_SUFFIX}.''${file_extension}"
        fi

        log "info" "Input file: $INPUT_FILE"
        log "info" "Target size: ''${TARGET_SIZE_MB}MB"
        log "info" "Output file: $OUTPUT_FILE"

        # Get video duration in seconds
        gum spin --spinner dot --title "Analyzing input video..." -- sh -c "
          DURATION=\$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 '$INPUT_FILE' 2>/dev/null)
          echo \"\$DURATION\" > /tmp/discordify_duration_$
        "
        DURATION=$(cat "/tmp/discordify_duration_$")
        rm -f "/tmp/discordify_duration_$"

        if [ -z "$DURATION" ] || [ "$(echo "$DURATION < 0" | bc -l 2>/dev/null)" = "1" ]; then
            log "abort" "Could not determine video duration"
        fi

        # Calculate target bitrate
        # Formula: (target_size_mb * 8192) / duration - audio_bitrate
        # 8192 = 8 * 1024 (convert MB to kilobits)
        AUDIO_BITRATE_NUM="''${AUDIO_BITRATE//k/}"
        TARGET_BITRATE=$(echo "scale=0; ((''${TARGET_SIZE_MB} * 8192) / $DURATION) - $AUDIO_BITRATE_NUM" | bc -l)

        # Ensure minimum bitrate
        MIN_BITRATE=64
        if [ "$(echo "$TARGET_BITRATE < $MIN_BITRATE" | bc -l)" = "1" ]; then
            log "warn" "Calculated bitrate is very low (''${TARGET_BITRATE}k). Setting to minimum ''${MIN_BITRATE}k"
            TARGET_BITRATE=$MIN_BITRATE
        fi

        log "info" "Video duration: ''${DURATION}s"
        log "info" "Calculated video bitrate: ''${TARGET_BITRATE}k"

        # Two-pass encoding for better quality at target bitrate
        log "info" "Starting two-pass encoding..."

        # Pass 1 - with spinner
        if [ -n "$verbose" ]; then
          log "info" "Pass 1/2: Analyzing video..."
          if ! ffmpeg -y -i "$INPUT_FILE" \
              -c:v libx264 \
              -b:v "''${TARGET_BITRATE}k" \
              -pass 1 \
              -an \
              -f null \
              /dev/null; then
              log "abort" "First pass failed"
          fi
        else
          if ! gum spin --spinner dot --title "Pass 1/2: Analyzing video..." -- sh -c "
            ffmpeg -y -i \"$INPUT_FILE\" \
              -c:v libx264 \
              -b:v \"''${TARGET_BITRATE}k\" \
              -pass 1 \
              -an \
              -f null \
              /dev/null >/dev/null 2>&1
          "; then
              log "abort" "First pass failed"
          fi
        fi

        # Pass 2 - with spinner
        if [ -n "$verbose" ]; then
          log "info" "Pass 2/2: Encoding video..."
          if ! ffmpeg -i "$INPUT_FILE" \
              -c:v libx264 \
              -b:v "''${TARGET_BITRATE}k" \
              -pass 2 \
              -c:a aac \
              -b:a "$AUDIO_BITRATE" \
              -movflags +faststart \
              "$OUTPUT_FILE"; then
              log "abort" "Second pass failed"
          fi
        else
          if ! gum spin --spinner dot --title "Pass 2/2: Encoding video..." -- sh -c "
            ffmpeg -i \"$INPUT_FILE\" \
              -c:v libx264 \
              -b:v \"''${TARGET_BITRATE}k\" \
              -pass 2 \
              -c:a aac \
              -b:a \"$AUDIO_BITRATE\" \
              -movflags +faststart \
              \"$OUTPUT_FILE\" >/dev/null 2>&1
          "; then
              log "abort" "Second pass failed"
          fi
        fi

        # Clean up pass files
        rm -f ffmpeg2pass-0.log ffmpeg2pass-0.log.mbtree

        # Check final file size
        if [ -f "$OUTPUT_FILE" ]; then
            FINAL_SIZE=$(stat -f%z "$OUTPUT_FILE" 2>/dev/null || stat -c%s "$OUTPUT_FILE" 2>/dev/null)
            FINAL_SIZE_MB=$(echo "scale=2; $FINAL_SIZE / 1048576" | bc -l)

            log "info" "Compression complete!"
            log "info" "Final file size: ''${FINAL_SIZE_MB}MB"
            log "info" "Output saved as: $OUTPUT_FILE"

            # Check if we're close to target - escape the hash for nix
            DIFF=$(echo "scale=2; $FINAL_SIZE_MB - ''${TARGET_SIZE_MB}" | bc -l)
            abs_diff="''${DIFF#-}"
            if [ "$(echo "$abs_diff > 1" | bc -l)" = "1" ]; then
                log "warn" "Final size differs from target by ''${DIFF}MB"
            fi
        else
            log "abort" "Output file was not created"
        fi
      '';
  };
in {
  config = {
    home.packages = [discordify];
  };
}
