# Chatwoot

> Open-source customer engagement suite.

A self-hosted alternative to Intercom, Zendesk, and Salesforce Service Cloud.

## Environment Variables

| Variable | Example | Description |
| :--- | :--- | :--- |
| `CHATWOOT_DOMAIN` | `chatwoot.rafhael.com.br` | Main URL for the application. |
| `HOST_DATA_PATH` | `/home/rafhael/chatwoot_data` | Host folder for storage/uploads. |
| `SECRET_KEY_BASE` | `(random string)` | 64-char random string for Rails security. |
| `POSTGRES_HOST` | `postgres` | Hostname of the DB container (from `infra-db`). |
| `POSTGRES_PASSWORD` | `YourStrongPassword123` | Same password defined in `infra-db`. |
| `REDIS_HOST` | `redis` | Hostname of the Redis container (from `infra-db`). |
| `REDIS_PASSWORD` | `YourRedisPassword123` | Same password defined in `infra-db`. |
| `REDIS_URL` | `redis://:Pass@redis:6379` | Full connection string (update password). |
| `MAILER_SENDER_EMAIL` | `Chatwoot <no-reply@x.com>` | The "From" address for emails. |
| `SMTP_ADDRESS` | `smtp.resend.com` | SMTP Server Host. |
| `SMTP_USERNAME` | `resend` | SMTP Username. |
| `SMTP_PASSWORD` | `re_123456` | SMTP Password/API Key. |