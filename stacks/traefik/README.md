# Traefik Proxy

> The edge router and Load Balancer.

This stack sets up **Traefik** as the main entry point for the server. It handles automatic SSL certificate generation (Let's Encrypt) and routes traffic to other containers based on domain labels.

## Environment Variables

| Variable | Example | Description |
| :--- | :--- | :--- |
| `ACME_EMAIL` | `your@email.com` | Email used for Let's Encrypt registration. |
| `TRAEFIK_DOMAIN` | `traefik.rafhael.com.br` | Domain to access the Traefik Dashboard. |
| `CF_API_EMAIL` | `your@email.com` | *(Optional)* Required only if using Cloudflare DNS Challenge. |
| `HOST_DATA_PATH` | `/home/rafhael/traefik_data` | Host folder where `acme.json` (certificates) will be saved. |

## Setup Notes

1. Ensure port **80** and **443** are open on your firewall.
2. Create the `acme.json` file manually if it doesn't exist, with strict permissions:
   ```bash
   touch ${HOST_DATA_PATH}/acme.json
   chmod 600 ${HOST_DATA_PATH}/acme.json
   ```