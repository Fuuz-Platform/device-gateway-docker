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

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31mError:\033[0m %s\n' "$1" >&2; }

# --- Preflight -------------------------------------------------------------
if ! command -v docker >/dev/null 2>&1; then
  err "Docker is not installed. Install Docker first: https://docs.docker.com/get-docker/"
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
  info "Writing docker-compose.yml"
  cat > docker-compose.yml <<'YAML'
services:
  fuuzdevicegateway:
    hostname: fuuz-device-gateway
    image: public.ecr.aws/fuuz/build/native-app-device-gateway-server:latest
    restart: always
    stop_grace_period: 60s
    ports:
      - 5500-5550:5500-5550
    extra_hosts:
      - host.docker.internal:host-gateway
    environment:
      NODE_ENV: production
    command: /fuuzdevicegateway/fuuzdevicegateway
    volumes:
      - ./.gatewaydata/appData:/root/.fuuzdevicegateway/
      - ./.gatewaydata/drivers:/fuuzdevicegateway/drivers/
    pull_policy: always
YAML
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
