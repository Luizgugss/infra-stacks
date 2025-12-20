# 🚀 Docker Infrastructure

These are my Docker stacks, designed to be deployed on `bare metal` or via Portainer. The current stacks include:

- Traefik (Reverse Proxy)
- Infra (Postgres + Redis)
- Chatwoot
- Evolution API
- n8n
- Monitoring (Prometheus + Grafana)

## 🛠️ Environment Variables

Below is the list of variables required to configure each stack in Portainer. Replace the example values with your actual data.

### 1. Traefik (Proxy & SSL)
| Variable | Example | Description |
| :--- | :--- | :--- |
| `ACME_EMAIL` | `your@email.com` | Email for registering Let's Encrypt certificates. |
| `TRAEFIK_DOMAIN` | `traefik.rafhael.com.br` | Access domain for the Dashboard. |
| `CF_API_EMAIL` | `your@email.com` | *(Optional)* Only if using Cloudflare DNS Challenge. |
| `HOST_DATA_PATH` | `/home/rafhael/traefik_data` | Folder where `acme.json` will be saved. |

---

### 2. Infrastructure (Postgres & Redis)
| Variable | Example | Description |
| :--- | :--- | :--- |
| `POSTGRES_USER` | `postgres` | Master database user. |
| `POSTGRES_PASSWORD` | `YourStrongPassword123` | Master database password. |
| `POSTGRES_DB` | `postgres` | Default initial database. |
| `REDIS_PASSWORD` | `YourRedisPassword123` | Redis access password. |
| `HOST_DATA_PATH` | `/home/rafhael/infra_data` | Folder where DB and Redis data will be saved. |

---

### 3. Monitoring (Prometheus & Grafana)
| Variable | Example | Description |
| :--- | :--- | :--- |
| `GRAFANA_DOMAIN` | `monitor.rafhael.com.br` | Grafana access domain. |
| `GRAFANA_USER` | `admin` | Initial Grafana user. |
| `GRAFANA_PASSWORD` | `YourGrafanaPassword` | Initial Grafana password. |
| `HOST_DATA_PATH` | `/home/rafhael/monitoring` | Where the `prometheus.yml` file will be located. |

---

### 4. Chatwoot
| Variable | Example | Description |
| :--- | :--- | :--- |
| `CHATWOOT_DOMAIN` | `chatwoot.rafhael.com.br` | Main Chatwoot domain. |
| `HOST_DATA_PATH` | `/home/rafhael/chatwoot_data` | Where to save uploads/files. |
| `SECRET_KEY_BASE` | `(generate a random string)` | Rails security key. |
| `POSTGRES_HOST` | `postgres` | Database container name. |
| `POSTGRES_PASSWORD` | `YourStrongPassword123` | Same password as Infrastructure. |
| `REDIS_HOST` | `redis` | Redis container name. |
| `REDIS_PASSWORD` | `YourRedisPassword123` | Same password as Infrastructure. |
| `REDIS_URL` | `redis://:Password@redis:6379` | Full connection URL. |
| `MAILER_SENDER_EMAIL` | `Chatwoot <no-reply@your.com>` | Name/Email for sending emails. |
| `SMTP_ADDRESS` | `smtp.resend.com` | SMTP Host. |
| `SMTP_USERNAME` | `resend` | SMTP User. |
| `SMTP_PASSWORD` | `re_123456` | SMTP Password. |

---

### 5. Evolution API
| Variable | Example | Description |
| :--- | :--- | :--- |
| `EVOLUTION_DOMAIN` | `evo.rafhael.com.br` | API domain. |
| `HOST_DATA_PATH` | `/home/rafhael/evolution_data` | Where to save WhatsApp instances. |
| `AUTHENTICATION_API_KEY`| `YourSecretApiKey` | Global key to control the API. |
| `DATABASE_CONNECTION_URI` | `postgresql://...` | Postgres Connection String. |

---

### 6. N8N
| Variable | Example | Description |
| :--- | :--- | :--- |
| `N8N_DOMAIN` | `n8n.rafhael.com.br` | N8N Domain. |
| `HOST_DATA_PATH` | `/home/rafhael/n8n_data` | Where to save workflows and credentials. |
| `GENERIC_TIMEZONE` | `America/Sao_Paulo` | Timezone. |

---

## 📂 Configuration Files

### Prometheus
This file must be manually created on the server at:
`${HOST_DATA_PATH}/prometheus/prometheus.yml`

```yaml
global:
  scrape_interval: 15s  # How often to scrape targets
  scrape_timeout: 10s   # Timeout for scraping

scrape_configs:
  - job_name: 'services'
    metrics_path: /metrics
    static_configs:
      - targets:
          - 'prometheus:9090'
          - 'node-exporter:9100'
          - 'cadvisor:8080'
```