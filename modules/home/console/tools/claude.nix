{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) attrValues;
  cfg = osConfig.ooknet.console.tools.claude;

  # reusable usage core. fetches the oauth usage endpoint (same data as /usage and
  # the website usage tab), caches with stale-while-revalidate. quickshell reads this too.
  ookusage = pkgs.writeShellApplication {
    name = "ookusage";
    runtimeInputs = attrValues {
      inherit (pkgs) jq curl coreutils util-linux;
    };
    text = ''
      # ookusage - claude subscription usage (% of 5h + weekly limits) from the
      # oauth usage endpoint. emits the raw endpoint json, cached. token is read
      # internally, never logged; cache holds only percentages.
      #   ookusage           print cache, refresh in background if stale (swr)
      #   ookusage refresh   force fetch, print
      #   ookusage __bg      internal: non-blocking fetch, silent
      set -euo pipefail

      endpoint="https://api.anthropic.com/api/oauth/usage"
      cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/ookusage"
      cache="$cache_dir/usage.json"
      lock="$cache_dir/.lock"
      ttl="''${OOKUSAGE_TTL:-60}"

      get_token() {
        local t=""
        if [[ -n "''${CLAUDE_CODE_OAUTH_TOKEN:-}" ]]; then printf '%s' "$CLAUDE_CODE_OAUTH_TOKEN"; return; fi
        # linux: plaintext credentials file
        if [[ -r "$HOME/.claude/.credentials.json" ]]; then
          t="$(jq -r '.claudeAiOauth.accessToken // empty' "$HOME/.claude/.credentials.json" 2>/dev/null || true)"
        fi
        # linux: libsecret keyring
        if [[ -z "$t" ]] && command -v secret-tool >/dev/null 2>&1; then
          t="$(secret-tool lookup service "Claude Code-credentials" 2>/dev/null \
               | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null || true)"
        fi
        # macos: keychain
        if [[ -z "$t" ]] && command -v security >/dev/null 2>&1; then
          t="$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null \
               | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null || true)"
        fi
        printf '%s' "$t"
      }

      fetch() {
        local tok; tok="$(get_token)"
        [[ -z "$tok" ]] && return 1
        curl -sS --max-time 10 "$endpoint" \
          -H "Authorization: Bearer $tok" \
          -H "anthropic-beta: oauth-2025-04-20"
      }

      refresh() { # $1 = -n for non-blocking bg refresh
        mkdir -p "$cache_dir"
        exec 9>"$lock"
        if [ "''${1:-}" = "-n" ]; then flock -n 9 || return 0; else flock 9 || return 0; fi
        local tmp; tmp="$(mktemp "$cache.XXXXXX")"
        # only replace cache if we got a sane response (has five_hour)
        if fetch >"$tmp" 2>/dev/null && jq -e '.five_hour' "$tmp" >/dev/null 2>&1; then
          mv "$tmp" "$cache"
        else
          rm -f "$tmp"
          return 1
        fi
      }

      case "''${1:-}" in
        refresh) refresh || true; cat "$cache" 2>/dev/null || echo '{"error":"fetch failed"}' ;;
        __bg)    refresh -n || true ;;
        *)
          if [[ -f "$cache" ]]; then
            cat "$cache"
            age=$(( $(date +%s) - $(stat -c %Y "$cache") ))
            if (( age > ttl )); then
              setsid -f "$0" __bg >/dev/null 2>&1 || nohup "$0" __bg >/dev/null 2>&1 &
            fi
          else
            refresh || true
            cat "$cache" 2>/dev/null || echo '{"error":"fetch failed"}'
          fi
          ;;
      esac
    '';
  };

  # claude status line formatter. model/dir/git + usage %
  claude-statusline = pkgs.writeShellApplication {
    name = "claude-statusline";
    runtimeInputs =
      [ookusage]
      ++ attrValues {
        inherit (pkgs) jq git coreutils gawk;
      };
    text = ''
      # claude-statusline - model/dir/git + claude subscription usage % (5h + weekly)
      # pulls live usage from `ookusage` (oauth usage endpoint, matches the website)
      set -euo pipefail

      input="$(cat)"
      usage="$(ookusage 2>/dev/null || echo '{}')"

      model="$(jq -r '.model.display_name // .model.id // "claude"' <<<"$input")"
      dir="$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")"
      [[ -z "$dir" ]] && dir="$PWD"
      branch="$(git -C "$dir" branch --show-current 2>/dev/null || true)"
      short="''${dir/#$HOME/\~}"

      # ansi
      d=$'\e[2m'; x=$'\e[0m'; bold=$'\e[1m'; blue=$'\e[34m'; grn=$'\e[32m'
      sep="  ''${d}│''${x}  "
      pctcol() { awk -v p="$1" 'BEGIN{p+=0; if(p>=90)printf"\033[31m";else if(p>=70)printf"\033[33m";else printf"\033[32m"}'; }
      fmt_reset() { # iso -> local HH:MM, or "Day HH:MM" if >24h away
        local iso="$1"; [[ -z "$iso" || "$iso" == "null" ]] && return
        local e now; e="$(date -d "$iso" +%s 2>/dev/null)" || return; now="$(date +%s)"
        if (( e - now < 86400 )); then date -d "$iso" +%H:%M; else date -d "$iso" +'%a %H:%M'; fi
      }
      seg() { # label util reset_iso -> "label NN% ↺HH:MM" colored, or nothing if util empty
        local label="$1" util="$2" iso="$3"
        [[ -z "$util" || "$util" == "null" ]] && return
        local rs; rs="$(fmt_reset "$iso")"
        printf '%s %s%.0f%%%s' "$label" "$(pctcol "$util")" "$util" "$x"
        [[ -n "$rs" ]] && printf ' %s↺%s%s' "$d" "$rs" "$x"
      }

      # newline-delimited (mapfile) so empty fields like a null opus slot are preserved
      mapfile -t U < <(jq -r '
        (.five_hour.utilization      // "" | tostring),
        (.five_hour.resets_at        // ""),
        (.seven_day.utilization      // "" | tostring),
        (.seven_day.resets_at        // ""),
        (.seven_day_opus.utilization // "" | tostring),
        (.seven_day_opus.resets_at   // "")
      ' <<<"$usage")
      fh="''${U[0]:-}"; fh_r="''${U[1]:-}"; sd="''${U[2]:-}"; sd_r="''${U[3]:-}"; op="''${U[4]:-}"; op_r="''${U[5]:-}"

      # left: context
      printf '%s%s%s  %s%s%s' "$bold" "$model" "$x" "$blue" "$short" "$x"
      [[ -n "$branch" ]] && printf '  %s %s%s' "$grn" "$branch" "$x"

      # right: usage. weekly opus only shown when the plan reports it (non-null)
      if [[ -z "$fh$sd" ]]; then
        printf '%s%susage n/a%s' "$sep" "$d" "$x"
      else
        printf '%s%s' "$sep" "$(seg 5h "$fh" "$fh_r")"
        printf '%s%s' "$sep" "$(seg wk "$sd" "$sd_r")"
        [[ -n "$op" && "$op" != "null" ]] && printf '%s%s' "$sep" "$(seg opus "$op" "$op_r")"
      fi
      printf '\n'
    '';
  };
in {
  config = mkIf cfg.enable {
    home.packages = [ookusage claude-statusline];
  };
}
