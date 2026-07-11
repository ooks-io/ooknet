{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (osConfig.ooknet.workstation) profiles;
  join-jam = pkgs.writeShellApplication {
    name = "join-jam";
    runtimeInputs = with pkgs; [wl-clipboard curl spotify];
    text = ''
      ua="Mozilla/5.0 (X11; Linux x86_64)"
      url=$(wl-paste)

      if [ -z "$url" ]; then
        echo "clipboard is empty" >&2
        exit 1
      fi

      # keep the ?si= token, its the join credential
      case "$url" in
        spotify:socialsession:* | *open.spotify.com/socialsession/*)
          target="$url" ;;
        *spotify.link/* | *spotify.app.link/*)
          target=$(curl -sIL -A "$ua" "$url" \
            | tr -d '\r' \
            | grep -oiE 'https://open\.spotify\.com/socialsession/[^[:space:]]+' \
            | head -n1 || true) ;;
        *)
          echo "clipboard is not a spotify jam link: $url" >&2
          exit 1 ;;
      esac

      if [ -z "$target" ]; then
        echo "couldn't find a jam in that link: $url" >&2
        exit 1
      fi

      echo "joining jam: $target"
      # already-running spotify forwards the url and returns nonzero, thats fine
      spotify "$target" || true
    '';
  };
in {
  config = mkIf (elem "media" profiles) {
    home.packages = [join-jam];
  };
}
