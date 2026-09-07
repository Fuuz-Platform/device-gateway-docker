# Fuuz Device Gateway — Docker

> **Beta — not an accelerator.** Published as a working concept to read, run
> and take the pattern from. It is not a supported deliverable, it carries no service
> level agreement, and it may change or be withdrawn without notice.

Run the Fuuz Device Gateway on any machine with [Docker](https://docs.docker.com/get-docker/) in one command.

## Prerequisites

- **A working Fuuz Enterprise environment.** The gateway connects to your Fuuz Enterprise tenant. You'll need either:
  - a **free limited trial license**, or
  - a **full Enterprise-scale subscription** (public or private cloud).

  Don't have one yet? [Get started with Fuuz](https://fuuz.com).
- **Docker Engine with the Compose plugin** (`docker compose version` should print a version). On macOS/Windows, install [Docker Desktop](https://www.docker.com/products/docker-desktop/).
- No registry login or credentials required — the gateway image is pulled anonymously from a public registry.

## Quick start

### Option A — one-line installer

```bash
curl -fsSL https://raw.githubusercontent.com/Fuuz-Platform/device-gateway-docker/main/install.sh | bash
```

This creates a `fuuz-device-gateway/` folder in your current directory, writes the compose file, and starts the gateway.

### Option B — clone the repo

```bash
git clone https://github.com/Fuuz-Platform/device-gateway-docker.git
cd device-gateway-docker
docker compose up -d
```

Either way, the gateway is now running in the background.

Check that it's up:

```bash
docker compose ps
docker compose logs -f
```

## Updates

**You do not upgrade the gateway from the command line.** Once it's running and connected to your Fuuz Enterprise tenant, updates are managed **from within the running application at runtime** — new packages and releases are delivered and applied automatically. There's no need to `docker compose pull` or re-run the installer to stay current.

## Managing the gateway

| Task | Command |
|------|---------|
| View logs | `docker compose logs -f` |
| Restart | `docker compose restart` |
| Stop & remove container | `docker compose down` |
| Start again | `docker compose up -d` |

Run these from the folder that contains `docker-compose.yml`.

## What gets created

The gateway stores its configuration and state in a `.gatewaydata/` folder next to `docker-compose.yml`:

- `.gatewaydata/appData` — gateway config, registration, and runtime state
- `.gatewaydata/drivers` — custom device drivers

**Back up `.gatewaydata/` and do not delete it** — removing it wipes the gateway's configuration. It is git-ignored so your local state is never committed.

## Notes

- **Ports** — the gateway publishes host ports `5500–5550`. Make sure nothing else on the machine is using that range.
- **Reaching the host** — `host.docker.internal` resolves to the host machine from inside the container, so the gateway can talk to services (OPC-UA, Modbus, the Fuuz platform, etc.) running on the host.

## Service levels

No service level agreement applies to anything published here. It becomes a supported
deliverable only once it has been implemented by a Fuuz services professional or an
approved Fuuz partner.
