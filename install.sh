#!/usr/bin/env bash
#
# Fuuz Device Gateway — one-line installer
#
#   curl -fsSL https://raw.githubusercontent.com/Fuuz-Platform/device-gateway-docker/main/install.sh | bash
#
# Creates ./fuuz-device-gateway, writes docker-compose.yml, and starts the gateway.
# Requires: Docker Engine with the Compose plugin, and a working Fuuz Enterprise
# environment (free trial or Enterprise subscription) for the gateway to connect to.

set -euo pipefail

INSTALL_DIR="${FUUZ_GATEWAY_DIR:-fuuz-device-gateway}"
REPO_RAW="${FUUZ_GATEWAY_REPO_RAW:-https://raw.githubusercontent.com/Fuuz-Platform/device-gateway-docker/main}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31mError:\033[0m %s\n' "$1" >&2; }

# --- Preflight -------------------------------------------------------------
if ! command -v docker >/dev/null 2>&1; then
  err "Docker is not installed. Install Docker first: https://docs.docker.com/get-docker/"
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  err "curl is required to download the compose file."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  err "The Docker Compose plugin is not available. Install/upgrade Docker (Desktop includes it): https://docs.docker.com/compose/install/"
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  err "Cannot talk to the Docker daemon. Is Docker running (and do you have permission)?"
  exit 1
fi

# --- Scaffold --------------------------------------------------------------
info "Creating '$INSTALL_DIR'"
mkdir -p "$INSTALL_DIR/.gatewaydata/appData" "$INSTALL_DIR/.gatewaydata/drivers"
cd "$INSTALL_DIR"

if [ -f docker-compose.yml ]; then
  info "docker-compose.yml already exists — leaving it as-is"
else
  info "Downloading docker-compose.yml"
  curl -fsSL "$REPO_RAW/docker-compose.yml" -o docker-compose.yml
fi

# --- Launch ----------------------------------------------------------------
info "Starting the Fuuz Device Gateway"
docker compose up -d

echo
info "Done. The gateway is running."
echo "  Directory : $(pwd)"
echo "  Logs      : (cd $(pwd) && docker compose logs -f)"
echo "  Status    : (cd $(pwd) && docker compose ps)"
echo
echo "Updates are delivered automatically from within the running application —"
echo "no need to re-run this installer or pull images manually."
