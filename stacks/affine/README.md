# AFFiNE

> Next-gen knowledge base and whiteboard. 

A workspace for docs, whiteboards, and databases _(a very good open source Notion/Miro alternative)_.

## Environment Variables

| Variable | Example | Description |
| :--- | :--- | :--- |
| `AFFINE_DOMAIN` | `docs.rafhael.com.br` | Domain to access AFFiNE. |
| `AFFINE_SERVER_PORT` | `3000` | Internal container port (usually 3000). |
| `HOST_DATA_PATH` | `/home/rafhael/affine_data` | Host folder to persist data and uploads. |
| `POSTGRES_PASSWORD` | `YourStrongPassword` | Password if running a dedicated DB inside stack. |

*(Check `docker-compose.yml` for specific DB connection variables if connecting to shared infrastructure).*