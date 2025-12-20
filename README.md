# Docker Infrastructure

> A battle-tested collection of **Docker Compose** stacks, optimized for self-hosted environments (VPS/Bare Metal) and orchestrated via **Portainer**.

This repository serves as the definitive **Infrastructure-as-Code (IaC)** catalog for my production services. Unlike generic templates, these stacks are:
- **Security-hardened:** Configured with strict network isolation and auto-SSL.
- **Resource-efficient:** Tuned for high performance on standard VPS hardware _(Hetzner, DigitalOcean)_.
- **Production-validated:** Currently powering live applications with real traffic.

## Repository Structure

| Directory | Purpose |
| :--- | :--- |
| **[Stacks](./stacks)** | **The Catalog.** Contains all services (Traefik, Chatwoot, Monitoring, etc). |
| **[Scripts](./scripts)** | Automation utilities (Backup, Restore, Maintenance). |
| **[Docs](./docs)** | Guides and tutorials (Swap Setup, Grafana Import). |

## Getting Started

### 1. Create a Shared Network
Before deploying any stack, you must create the external network that allows Traefik to route traffic to your containers.

Run this command on your host (via `ssh`):

```bash
docker network create proxy
```

**Note:** In Portainer, you can also create this manually under the "Networks" tab _(Name: proxy, Driver: bridge)_.

### 2. Configure Global Variables
Most stacks rely on the `HOST_DATA_PATH` variable to define where data is stored on your server
- **Recommended:** Define this in your .env file or Portainer Environment
- **Example:**
  ```ini
  HOST_DATA_PATH=/home/user/docker_data
  ```

### 3. Deploy a Stack
1. Browse the [**Stacks Catalog**](./stacks/README.md)
2. Choose a service (e.g., monitoring)
3. Follow the specific deployment instructions inside that folder

## Maintenance & Backups
This repository includes automated scripts to keep your data safe. Check the [**scripts folder**](./scripts/README.md) to set up the Automated Backup _(S3 + Local)_.

## License
This project is open-sourced software licensed under the MIT license.