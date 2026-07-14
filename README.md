# Fuuz Device Gateway — Docker

Run the Fuuz Device Gateway on any machine with [Docker](https://docs.docker.com/get-docker/) in one command.

## Prerequisites

- Docker Engine with the Compose plugin (`docker compose version` should print a version). On macOS/Windows, install [Docker Desktop](https://www.docker.com/products/docker-desktop/).
- No login or credentials required — the gateway image is pulled anonymously from a public registry.

## Quick start

```bash
git clone https://github.com/Fuuz-Platform/device-gateway-docker.git
cd device-gateway-docker
docker compose up -d
```

That's it. The gateway is now running in the background.

Check that it's up:

```bash
docker compose ps
docker compose logs -f
```

## Managing the gateway

| Task | Command |
|------|---------|
| View logs | `docker compose logs -f` |
| Restart | `docker compose restart` |
| Stop & remove container | `docker compose down` |
| Upgrade to the latest image | `docker compose pull && docker compose up -d` |

## What gets created

The gateway stores its configuration and state in a `.gatewaydata/` folder next to `docker-compose.yml`:

- `.gatewaydata/appData` — gateway config, registration, and runtime state
- `.gatewaydata/drivers` — custom device drivers

**Back up `.gatewaydata/` and do not delete it** — removing it wipes the gateway's configuration. It is git-ignored so your local state is never committed.

## Notes

- **Ports** — the gateway publishes host ports `5500–5550`. Make sure nothing else on the machine is using that range.
- **Reaching the host** — `host.docker.internal` resolves to the host machine from inside the container, so the gateway can talk to services (OPC-UA, Modbus, the Fuuz platform, etc.) running on the host.
- **Image tag** — this uses `:latest`. For a locked-down deployment, pin a specific image tag in `docker-compose.yml`.
