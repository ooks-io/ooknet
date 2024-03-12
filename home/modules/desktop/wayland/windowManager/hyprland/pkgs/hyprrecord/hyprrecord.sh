#!/usr/bin/env bash

getTargetDirectory() {
  test -f "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs" &&
    . "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
  echo "${XDG_RECORDINGS_DIR:-${XDG_VIDEOS_DIR:-$HOME}}"
}

SINK="$(pactl get-default-sink).monitor"
AUDIO=""
FILE="--file=$(getTargetDirectory)/$(date -Ins).mp4"
SET_REGION=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
  -a | --audio)
    AUDIO="--audio=$SINK"
    shift
    ;;
  -r | --region)
    SET_REGION=true
    shift
    ;;
  *)
    echo "Unknown parameter passed: $1"
    exit 1
    ;;
  esac
done

notify() {
  notify-send -t 5000 -a system-notify "$@"
}

takeRecording() {
  if pgrep -x "wf-recorder" >/dev/null; then
    pkill -x "wf-recorder"
    notify "Recording Stopped"
  else
    # Only invoke slurp if starting a new recording and the region option was set
    if [ "$SET_REGION" = true ]; then
      REGION="--geometry=$(slurp)"
    fi
    wf-recorder "$AUDIO" "$REGION" "$FILE"
  fi
}

echo $(takeRecording)
