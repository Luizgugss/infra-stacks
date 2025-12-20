# Infrastructure (Databases)

> Shared PostgreSQL and Redis services.

This stack provides centralized database and caching services. Other stacks (like Chatwoot or N8N) connect to these containers instead of running their own isolated databases.

## Environment Variables

| Variable | Example | Description |
| :--- | :--- | :--- |
| `POSTGRES_USER` | `postgres` | The master username for PostgreSQL. |
| `POSTGRES_PASSWORD` | `YourStrongPassword123` | The master password for PostgreSQL. |
| `POSTGRES_DB` | `postgres` | Default initial database name. |
| `REDIS_PASSWORD` | `YourRedisPassword123` | Password for Redis authentication. |
| `HOST_DATA_PATH` | `/home/rafhael/infra_data` | Host folder to persist Database and Redis data. |

## Important
Deploy this stack **before** deploying applications that depend on it. Ensure all stacks share the same Docker Network to allow internal communication.