# Chatwoot Production Stack

A production-ready deployment of **Chatwoot**, the open-source customer engagement platform. This stack provides a self-hosted alternative to Intercom, Zendesk, and Salesforce Service Cloud.

## What is Chatwoot?

Chatwoot is a customer support tool that allows you to manage conversations across multiple channels (Website Widget, Email, Facebook, Twitter, WhatsApp, SMS) from a unified dashboard.

**Key Features:**
- Omnichannel inbox (Website, Email, Facebook, WhatsApp, etc.)
- Agent collaboration with private notes
- Customer management with custom attributes
- CSAT surveys and reports
- API for custom integrations
- Self-hosted for data privacy

## Architecture

This stack includes two containers:

* **chatwoot_web:** The main Rails application serving the web interface and API.
* **chatwoot_sidekiq:** Background job processor for async tasks (emails, webhooks, notifications).

Both containers share the same codebase and connect to external services:
- **PostgreSQL** (from `infra-db` stack)
- **Redis** (from `infra-db` stack)
- **SMTP Server** (for sending emails)

## Prerequisites

### 1. Deploy Required Infrastructure

Chatwoot requires PostgreSQL and Redis. Deploy the `infra-db` stack first:

```bash
cd stacks/infra-db
docker compose up -d
```

### 2. Configure SMTP Server

Chatwoot sends emails for:
- User invitations
- Password resets
- Conversation assignments
- CSAT surveys

**Recommended Providers:**
- [Resend](https://resend.com) - 100 emails/day free
- [SendGrid](https://sendgrid.com) - 100 emails/day free
- [Mailgun](https://mailgun.com) - 5,000 emails/month free
- Gmail SMTP (for testing only)

### 3. Generate Secret Key

Chatwoot uses `SECRET_KEY_BASE` for encrypting sessions and sensitive data.

```bash
openssl rand -hex 64
```

Copy the output to your `.env` file.

## Setup Instructions

### Step 1: Configure Environment Variables

Copy the example file and configure your secrets:

```bash
cp .env.example .env
```

**Required Variables:**

| Variable | Example | Description |
|----------|---------|-------------|
| `CHATWOOT_DOMAIN` | `chat.yourdomain.com` | Domain where Chatwoot will be accessible |
| `HOST_DATA_PATH` | `/home/user/chatwoot_data` | Host folder for uploads and attachments |
| `SECRET_KEY_BASE` | `(64-char hex string)` | Generate with `openssl rand -hex 64` |
| `POSTGRES_HOST` | `postgres` | Hostname of PostgreSQL container (use `postgres` if using infra-db) |
| `POSTGRES_PASSWORD` | `YourStrongPassword123` | Same password defined in infra-db stack |
| `REDIS_HOST` | `redis` | Hostname of Redis container (use `redis` if using infra-db) |
| `REDIS_PASSWORD` | `YourRedisPassword123` | Same password defined in infra-db stack |
| `REDIS_URL` | `redis://:YourRedisPassword123@redis:6379` | Full Redis connection string |
| `MAILER_SENDER_EMAIL` | `Chatwoot <noreply@yourdomain.com>` | "From" address for emails |
| `SMTP_ADDRESS` | `smtp.resend.com` | SMTP server hostname |
| `SMTP_USERNAME` | `resend` | SMTP username |
| `SMTP_PASSWORD` | `re_abc123xyz` | SMTP password or API key |

**Important:** Ensure `REDIS_URL` includes the password: `redis://:PASSWORD@redis:6379`

### Step 2: Start the Stack

```bash
docker compose up -d
```

Chatwoot will automatically run database migrations on startup.

### Step 3: Create Super Admin Account

After the containers are running, create your first admin user:

```bash
docker compose exec chatwoot_web bundle exec rails runner 'User.create!(email: "admin@example.com", password: "YourStrongPassword", name: "Admin", confirmed_at: Time.now.utc, account: Account.create!(name: "My Company"))'
```

Replace:
- `admin@example.com` with your email
- `YourStrongPassword` with a secure password
- `My Company` with your company name

### Step 4: Access Chatwoot

Navigate to `https://your-chatwoot-domain.com` and log in with the credentials you just created.

## Post-Installation Configuration

### Add Inbox (Communication Channel)

1. Go to **Settings** > **Inboxes** > **Add Inbox**
2. Choose your channel type:
   - **Website:** Embeddable widget for your website
   - **Email:** Forward emails to Chatwoot
   - **API:** For custom integrations
   - **Facebook/Twitter/WhatsApp:** Requires OAuth setup

### Configure Website Widget

1. Create a **Website** inbox
2. Copy the JavaScript snippet
3. Add it to your website's `<head>` tag
4. Customize widget appearance in **Settings** > **Inboxes** > **Widget Settings**

### Invite Team Members

1. Go to **Settings** > **Agents**
2. Click **Add Agent**
3. Enter email and select role:
   - **Administrator:** Full access
   - **Agent:** Can handle conversations

## Integration with Evolution API (WhatsApp)

To connect WhatsApp via Evolution API:

### Step 1: Enable Chatwoot Integration in Evolution API

In Evolution API `.env`, set:
```bash
CHATWOOT_ENABLED=true
```

### Step 2: Create API Inbox in Chatwoot

1. Go to **Settings** > **Inboxes** > **Add Inbox**
2. Select **API**
3. Give it a name like "WhatsApp"
4. Copy the **Inbox Identifier** and **API Key**

### Step 3: Configure Evolution API Instance

When creating a WhatsApp instance in Evolution API, include:

```json
{
  "instanceName": "my-whatsapp",
  "integration": "CHATWOOT",
  "chatwootAccountId": "1",
  "chatwootToken": "YOUR_CHATWOOT_API_TOKEN",
  "chatwootUrl": "https://chat.yourdomain.com",
  "chatwootInboxId": "YOUR_INBOX_ID"
}
```

Replace placeholders with values from Chatwoot.

## Traefik Integration

This stack includes Traefik labels for automatic SSL certificate provisioning:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.chatwoot_r.rule=Host(`${CHATWOOT_DOMAIN}`)"
  - "traefik.http.routers.chatwoot_r.entrypoints=websecure"
  - "traefik.http.routers.chatwoot_r.tls.certresolver=myresolver"
```

Once the stack starts, Traefik will:
1. Detect the service via Docker labels
2. Generate a Let's Encrypt SSL certificate
3. Route HTTPS traffic to the container

## Common Issues

### 1. "Database does not exist" Error

**Problem:** Chatwoot cannot connect to PostgreSQL.

**Solution:**
```bash
# Create the database manually
docker compose exec chatwoot_web bundle exec rails db:create
docker compose exec chatwoot_web bundle exec rails db:migrate
```

### 2. Emails Not Sending

**Problem:** SMTP configuration incorrect.

**Debug Steps:**
1. Check SMTP credentials in `.env`
2. Test SMTP connection:
   ```bash
   docker compose exec chatwoot_web bundle exec rails console
   # In Rails console:
   ActionMailer::Base.mail(from: 'noreply@yourdomain.com', to: 'your-email@example.com', subject: 'Test', body: 'Test').deliver_now
   ```
3. Check logs: `docker compose logs chatwoot_web | grep -i smtp`

**Common Causes:**
- Wrong SMTP port (use 587 for TLS, 465 for SSL)
- Authentication disabled but required
- Firewall blocking outbound SMTP connections

### 3. "Redis connection refused"

**Problem:** Redis not running or wrong credentials.

**Solution:**
```bash
# Verify Redis is running
docker ps | grep redis

# Test Redis connection
docker compose exec chatwoot_web redis-cli -h redis -a YourRedisPassword ping
# Should return: PONG
```

Ensure `REDIS_URL` format is correct: `redis://:PASSWORD@redis:6379`

### 4. Sidekiq Jobs Not Processing

**Problem:** Background jobs stuck (emails, notifications not working).

**Solution:**
```bash
# Check Sidekiq logs
docker compose logs chatwoot_sidekiq --tail 50

# Restart Sidekiq
docker compose restart chatwoot_sidekiq

# Monitor Sidekiq dashboard
# Add to Chatwoot: https://chat.yourdomain.com/sidekiq
```

### 5. "Secret key base not set" Error

**Problem:** `SECRET_KEY_BASE` missing or invalid.

**Solution:**
```bash
# Generate new secret
openssl rand -hex 64

# Update .env file
SECRET_KEY_BASE=generated_value_here

# Restart stack
docker compose restart
```

### 6. File Uploads Not Working

**Problem:** Attachments fail to upload.

**Solution:**
```bash
# Check permissions on host
sudo chown -R 1000:1000 ${HOST_DATA_PATH}/storage

# Verify volume mount
docker compose exec chatwoot_web ls -la /app/storage
```

### 7. High Memory Usage

**Problem:** Chatwoot consumes excessive memory.

**Solution:**

Add memory limits to `docker-compose.yml`:
```yaml
services:
  chatwoot_web:
    mem_limit: 1g
  chatwoot_sidekiq:
    mem_limit: 512m
```

Optimize Sidekiq concurrency in `.env`:
```bash
SIDEKIQ_CONCURRENCY=5  # Reduce from default 10
```

## Maintenance

### Updating Chatwoot

```bash
# Pull latest image
docker compose pull

# Restart with new version
docker compose up -d

# Run migrations (if needed)
docker compose exec chatwoot_web bundle exec rails db:migrate
```

### Backing Up Data

**Database Backup:**
```bash
docker exec infra-db-postgres-1 pg_dump -U postgres chatwoot > chatwoot_backup_$(date +%Y%m%d).sql
```

**Uploads Backup:**
```bash
tar -czf chatwoot_uploads_$(date +%Y%m%d).tar.gz ${HOST_DATA_PATH}/storage
```

### Viewing Logs

```bash
# All containers
docker compose logs -f

# Specific container
docker compose logs -f chatwoot_web
docker compose logs -f chatwoot_sidekiq

# Last 100 lines
docker compose logs --tail 100 chatwoot_web
```

## Performance Tuning

### For Small Teams (1-10 agents)

Default configuration works well.

### For Medium Teams (10-50 agents)

Increase Sidekiq workers:
```yaml
services:
  chatwoot_sidekiq:
    environment:
      - SIDEKIQ_CONCURRENCY=10
    deploy:
      replicas: 2  # Run 2 Sidekiq containers
```

### For Large Teams (50+ agents)

Consider:
- Separate Redis for cache vs. queues
- PostgreSQL read replicas
- CDN for static assets
- External object storage (S3) for uploads

## Security Best Practices

1. **Use strong passwords** for `SECRET_KEY_BASE`, PostgreSQL, and Redis
2. **Enable 2FA** for admin accounts in Chatwoot settings
3. **Restrict API access** by IP if possible
4. **Regular backups** of database and uploads
5. **Update regularly** to patch security vulnerabilities
6. **Use HTTPS only** (enforced by Traefik)

## Resources

- [Official Documentation](https://www.chatwoot.com/docs)
- [API Reference](https://www.chatwoot.com/developers/api)
- [GitHub Repository](https://github.com/chatwoot/chatwoot)
- [Community Forum](https://github.com/chatwoot/chatwoot/discussions)
