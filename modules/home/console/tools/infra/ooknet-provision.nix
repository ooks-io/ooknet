{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (builtins) attrValues;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  config = mkIf (elem "infra" profiles) {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "ooknet-provision";
        runtimeInputs = attrValues {
          inherit
            (pkgs)
            gum
            jq
            coreutils
            nixos-anywhere
            ;
          # I could add 1password here but it is included in all workstation configurations by default
        };
        # wrapper around nixos-anywhere with 1password integration for fetching hostkeys for
        # secret decryption.
        # this script is not intended for general use, but specifically tailored to my needs.
        text = ''
          #TODO:
          # - add options for install-key/target user
          # - add log file output
          # - write this in go
          set -euo pipefail

          hostname=""
          targetIP=""
          targetUser="root"
          localHostConfigDir=""
          installKey=${config.home.homeDirectory}/.ssh/install-key
          additionalFlags=""
          verbose=""
          temp=$(mktemp -d)

          cleanup() {
            find "$temp" -type f -exec shred -uzn 3 {} \;
            rm -rf "$temp"
          }

          helpCmd() {
            cat <<USAGE

          Usage: ooknet-provision [target hostname] [target ip]

          Options:

          * -v, --verbose
            Enable verbose output
          * -o, --extra-options
            Pass additional options to nixos-anywhere
          * -h, --help
            Print help
          * -d, --host-config-dir
            Specify the location of the target hosts confuration location where hardware.nix will be written.
            Defaults to "<FLAKE>/hosts/<hostname>"
          USAGE
          }

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

          arguments() {
            while [[ $# -gt 0 ]]; do
              case "$1" in
              -h | --help)
                helpCmd
                exit 0
                ;;
              -v | --verbose)
                verbose="y"
                shift
                ;;
              -o | --extra-options)
                if [[ -z "$2" || "$2" == -* ]]; then
                  log abort "Missing value for -o, --extra-options"
                fi
                additionalFlags="$2"
                shift 2
                ;;
              -d | --host-config-dir)
                if [[ -z "$2" || "$2" == -* ]]; then
                  log abort "Missing value for -d, --host-config-dir"
                fi
                localHostConfigDir="$2"
                shift 2
                ;;
              -*)
                log abort "Unknown option: $1"
                ;;
              *)
                if [ -z "$hostname" ]; then
                  hostname="$1"
                elif [ -z "$targetIP" ]; then
                  targetIP="$1"
                else
                  log abort "Too many positional arguments: $1. Expected [hostname] [targetIP]"
                fi
                shift
                ;;
              esac
            done
            if [ -z "$hostname" ]; then
              log abort "Target hostname is required. Use: provision <hostname> <targetIP> [options]"
            fi

            if [ -z "$targetIP" ]; then
              log abort "Target IP address is required. Use: provision <hostname> <targetIP> [options]"
            fi

            if [ -z "$localHostConfigDir" ]; then
              if [ -n "$FLAKE" ]; then
                localHostConfigDir="$FLAKE/hosts/$hostname"
                log verbose "Defaulting local host config directory to: $localHostConfigDir"
              else
                log verbose "FLAKE variable not set; cannot form default for localHostConfigDir."
              fi
            else
              log verbose "Using specified local config directory $localHostConfigDir"
            fi
          }

          preChecks() {
            # we need to authenticate early
            log info "Authenicating with 1Password"
            if ! op account get >/dev/null; then
              log abort "Failed to authenicate with 1Password..."
            fi

            log info "Running pre-installation checks..."

            # have you set $FLAKE
            log verbose "Checking FLAKE variable is set..."
            if [ -z "$FLAKE" ]; then
              log abort "FLAKE variable unset, please set the FLAKE variable to the root location of the ooknet flake"
            else
              log verbose "FLAKE location found..."
            fi

            # is there a valid nixosConfigurations.$hostname flake output
            log verbose "Checking for nixosConfiguration.$hostname"
            if ! nix flake show "$FLAKE" \
              --json \
              --no-update-lock-file \
              --quiet \
              --all-systems |
              jq -e --arg hn "$hostname" '.nixosConfigurations[$hn]'; then
              log abort "nixosConfigurations.$hostname not found..."
            else
              log verbose "nixosConfigurations.$hostname found..."
            fi

            # ensure $hostname has valid configuration directory
            # we could make this more robust
            log verbose "Checking for $hostname configuration file"
            if [ ! -d "$localHostConfigDir" ]; then
              log abort "Host confguration directory: '$localHostConfigDir' (for hardware.nix) does not exist..."
            else
              log verbose "Host configuration directory: '$localHostConfigDir' found..."
            fi

            # does the configuration evaluate
            log verbose "Evaluting configuration"
            if ! nix eval --raw "$FLAKE"#nixosConfigurations."$hostname".config.system.build.toplevel; then
              log abort "nixosConfigurations.$hostname.config.system.build.toplevel failed to evaluate"
            else
              log verbose "nixosConfigurations.$hostname.config.system.build.toplevel successfully evaluated..."
            fi

            # for jq arg (there is a better way to do this...)
            local target_title="$hostname-hostkey"

            # have you setup a hostkey in 1Password
            log verbose "Checking if hostkey '$target_title' is available in 1Password"
            if ! op item list --vault ooknet --tags hostkey --format=json |
              jq -e --arg title_to_find "$target_title" 'any(.[]; .title == $title_to_find)'; then
              log abort "Hostkey '$target_title' not found in vault 'ooknet' with tag 'hostkey'. Ensure $hostname hostkey has been defined in 1Password"
            else
              log verbose "Hostkey found..."
            fi

            log verbose "Checking for install key"

            if [ ! -f "$installKey" ]; then
              log abort "Install key not found at $installKey"
            else
              log verbose "Install key found..."
            fi

            local ssh_output
            if ! ssh_output=$(ssh \
              -F /dev/null \
              -l "$targetUser" \
              -i "$installKey" \
              -o BatchMode=yes \
              -o StrictHostKeyChecking=no \
              -o ConnectTimeout=30 \
              "$targetIP" \
              true 2>&1); then
              log error "$ssh_output"
              log abort "$0 SSH connection to $targetUser@$targetIP cannot be established at this time..."
            else
              log info "SSH connection successful..."
            fi
            log info "All checks passed"
          }

          getHostKey() {
            log info "Retrieving Host keys from 1Password vault..."
            install -d -m755 "$temp/etc/ssh"
            if ! op read \
              --out-file "$temp/etc/ssh/ssh_host_ed25519_key" \
              --file-mode 0600 \
              "op://ooknet/$hostname-hostkey/private key"; then
              log abort "Failed to retrieve private host key"
            fi
            if ! op read \
              --out-file "$temp/etc/ssh/ssh_host_ed25519_key.pub" \
              --file-mode 0644 \
              "op://ooknet/$hostname-hostkey/public key"; then
              log abort "Failed to retrieve public host key"
            fi
          }

          deploySystem() {
            log info "Running nixos-anywhere..."

            if [ -z "$localHostConfigDir" ]; then
              log abort "localHostConfigDir is not set. This is a script bug or was not defaulted correctly"
            fi

            local hardware_config_path="$localHostConfigDir/hardware.nix"
            nixos_anywhere_cmd=(
              "nixos-anywhere"
              "--generate-hardware-config" "nixos-generate-config" "$hardware_config_path"
              "--extra-files" "$temp"
              "--flake" "$FLAKE#$hostname"
              "--target-host" "$targetUser@$targetIP"
              "-i" "$installKey"
            )
            log verbose "Base command: nixos-anywhere with standard options"

            if [ -n "$additionalFlags" ]; then
              log verbose "Adding additional flags: $additionalFlags"

              declare -a extra_args
              read -r -a extra_args <<<"$additionalFlags"

              for arg in "''${extra_args[@]}"; do
                nixos_anywhere_cmd+=("$arg")
              done

              log verbose "Command array now has ''${#nixos_anywhere_cmd[@]} elements. Full command: ''${nixos_anywhere_cmd[*]}"
            fi

            if [ -n "$verbose" ]; then
              log verbose "Executing: ''${nixos_anywhere_cmd[*]}"
            fi

            "''${nixos_anywhere_cmd[@]}"

            local exit_code=$?
            if [ $exit_code -eq 0 ]; then
              log info "nixos-anywhere completed successfully"
            else
              log error "nixos-anywhere failed with exit code $exit_code"
            fi
          }

          main() {
            arguments "$@"
            preChecks
            getHostKey
            deploySystem
            log info "Installation completed!"
          }

          if [ "$#" -lt 2 ]; then
            helpCmd
          fi

          trap cleanup EXIT
          main "$@"

        '';
      })
    ];
  };
}
