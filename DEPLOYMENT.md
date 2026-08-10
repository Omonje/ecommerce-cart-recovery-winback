# Deployment Notes

This project runs locally against the Docker Compose stack in
[`../infra/docker-compose.yml`](../infra/docker-compose.yml) (n8n +
Postgres + pgAdmin) for development and demo purposes. Moving it to a real
client engagement changes several things.

## n8n hosting

- **n8n Cloud** is the fastest path for a client with no infrastructure
  preferences, managed updates, managed backups, built-in HTTPS for
  webhooks. Simplest to hand off and support.
- **Self-hosted (Docker, on a VPS or the client's existing infra)** makes
  sense when the client wants data residency control or already runs other
  services that should share the same network/database. This is what the
  local dev stack here mirrors, the same `docker-compose.yml` pattern works
  in production with the changes below.

## What changes from this local setup

- **Secrets never live in files.** Every credential in this project
  (Shopify token, Postgres password, SMTP, Slack) belongs in n8n's built-in
  credential store or environment variables injected at deploy time, never
  committed to the repo or pasted into a SQL/config file. This project
  briefly had a real Shopify token pasted into `schema.sql` during setup,
  caught before it was committed, but it's the exact mistake this note
  exists to prevent happening for a client where the stakes are real.
- **Webhook exposure needs a real HTTPS endpoint.** Locally, the
  "Order Placed" webhook can only be hit with a manual test POST. In
  production it needs to be reachable at a real HTTPS URL, either n8n
  Cloud's endpoint, or a reverse proxy (Caddy/nginx) with a real domain and
  TLS cert in front of self-hosted n8n. A dev tunnel (ngrok/Cloudflare
  Tunnel) is fine for a demo, not for production traffic.
- **Managed Postgres instead of a local container.** The `app-db` container
  here is disposable dev state. Production needs a managed instance
  (RDS, Supabase, Neon, or the client's existing DB) with real backups, not
  a Docker volume on a single machine.
- **`GENERIC_TIMEZONE`/`TZ`** should be set to the client's actual business
  timezone, not left as the demo default, since the recovery scan's spacing
  logic and the daily win-back trigger time are both timezone-sensitive.
- **`N8N_SECURE_COOKIE=false`** is a local-HTTP-only convenience in this
  dev stack. Production behind real HTTPS should leave this unset
  (defaults to secure cookies) or explicitly `true`.

## Before going live for a real client

1. Confirm dry-run mode has run at least one full cycle and the "would-send"
   log matches expectations.
2. Confirm the Slack error-alert channel is one the client's team actually
   watches, not a placeholder channel.
3. Confirm the webhook URL is registered in the client's real Shopify (or
   other platform) webhook settings, not just reachable manually.
4. Flip `dry_run` to `false` only after 1-3 above are confirmed.

## Monitoring after launch

This project's Error Trigger → Slack branch covers workflow-level failures.
For a real client, pair it with n8n's own execution history retention
settings (don't let executions get pruned before anyone reviews a failure)
and, if this scales past a handful of workflows, look at the dedicated
"Production Automation Monitoring & Incident Response" build in this
portfolio, that project generalizes this exact pattern into standalone
health checks and daily summaries across multiple workflows.
