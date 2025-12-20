# Docker Infrastructure

> A battle-tested collection of **Docker Compose** stacks, optimized for self-hosted environments (VPS/Bare Metal) and orchestrated via **Portainer**.

This repository serves as the definitive **Infrastructure-as-Code (IaC)** catalog for my production services. Unlike generic templates, these stacks are:
* **Security-hardened:** Configured with strict network isolation and auto-SSL.
* **Resource-efficient:** Tuned for high performance on standard VPS hardware _(Hetzner, DigitalOcean)_.
* **Production-validated:** Currently powering live applications with real traffic.


## The Stack Catalog

| Stack | Category | Description |
| :--- | :--- | :--- |
| **[Monitoring](/stacks/monitoring)** | Observability | Prometheus, Grafana & Node Exporter stack for full server metrics. |
| **[Traefik](/stacks/traefik)** | Networking | Cloud-native reverse proxy and load balancer with auto SSL. |
| **[n8n](/stacks/n8n)** | Automation | Workflow automation tool (fair-code licensed). |
| **[Evolution API](/stacks/evolution-api)** | Messaging | WhatsApp API for managing messages and bots. |
| **[Chatwoot](/stacks/chatwoot)** | Support | Open-source customer engagement suite. |
| **[Affine](/stacks/affine)** | Productivity | Next-gen knowledge base and whiteboard (Notion/Miro alternative). |
| **[Infra DB](/stacks/infra-db/)** | Database | Centralized database containers (PostgreSQL/Redis) for shared services. |

## Guides

- [How Import Grafana Dashboards](/docs/import-grafana-dashboards.md)
- [How Setup Memory Swap](/docs/setup-swap.md)

## Deployment Guide

## Prerequisite: Shared Network
Before deploying any stack, you must create the external network that allows Traefik to route traffic to your containers.

Run this command on your host (via SSH):

```bash
docker network create proxy
```

**Note:** In Portainer, you can also create this manually under the "Networks" tab _(Name: proxy, Driver: bridge)_.

### Option A: Using Portainer (recommended)

1. Navigate to the folder of the desired stack (e.g., chatwoot/).
2. Copy the content of docker-compose.yml.
3. Create a new Stack in Portainer.
4. Paste the content.
5. Define the Environment Variables (listed in that stack's README) in the "Environment variables" section of Portainer.
6. Deploy the stack.

### Option B: Using Docker CLI
1.  Clone the repository:
    ```bash
    git clone [https://github.com/rmarsigli/infra-stacks.git](https://github.com/rmarsigli/infra-stacks.git)
    cd infra-stacks
    ```
2.  Enter the stack directory and deploy:
    ```bash
    cd monitoring
    # Create .env file with required variables first
    docker-compose up -d
    ```
3.  Check if containers are running
    ```
    docker-compose ps
    ```

## Environment Variables

Each **[stack directory](/stacks/)** contains its own `README.md` detailing the specific Environment Variables required for that service. Please check the documentation inside each folder before deploying.

## License
This project is open-sourced software licensed under the MIT license.