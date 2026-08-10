# Upwork Portfolio Entry (copy-paste ready, edit before posting)

**Title:** E-commerce Cart Recovery & Customer Win-Back Automation (n8n)

**Cover image:** screenshot the n8n canvas itself, it reads as more credible
than a stock graphic. The full architecture diagram lives in
[ARCHITECTURE.md](ARCHITECTURE.md) if you want to render that instead.

**Links to include in the listing:** [ARCHITECTURE.md](ARCHITECTURE.md),
[BUSINESS-CASE.md](BUSINESS-CASE.md), [DEPLOYMENT.md](DEPLOYMENT.md) — these
three are what separate this from a workflow screenshot, they show you can
reason about a system, not just assemble nodes.

**Description:**

Built a production-grade cart recovery and customer win-back system for an
e-commerce store using n8n and PostgreSQL.

The system runs two independent automations:

1. A recovery sequence that scans for abandoned carts every 15 minutes, segments
   shoppers by cart value and how many touches they've already received, and
   sends a 3-message sequence (standard reminder → incentive offer → final
   notice) with built-in spacing so customers aren't spammed.
2. A win-back automation that runs daily against customers inactive 90+ days,
   tiers the offer by lifetime value, and caps re-sends so the same customer
   isn't re-targeted more than once every 60 days.

Both feed into an order-webhook listener that immediately marks a cart as
converted the moment a real purchase lands — stopping the recovery sequence
before a customer who already bought gets another "come back" email. That
stop-on-conversion logic is the detail most cart-recovery automations skip, and
it's usually the first thing that erodes a client's trust in the system.

The workflow ships with a dry-run mode (flip one config flag to preview exactly
what would be sent before any real email goes out), and an error-alert branch
that pushes failures straight to Slack with the failing node and execution ID —
so issues get caught by the team, not reported by an annoyed customer.

**Skills tags:** n8n, PostgreSQL, Email Automation, CRM Integration, Marketing
Automation, Workflow Automation, API Integration

**Before posting, confirm:**
- [ ] Placeholder store name/emails in the workflow (`yourstore-demo.com`)
      are replaced with your actual demo branding, not left as-is
- [ ] Loom recorded (60-90 seconds), walking through the segmentation logic
      and the stop-on-conversion webhook specifically, that's what turns
      this from "a screenshot" into "proof you understand production
      systems"
- [ ] Repo is public (or the listing links a private repo invite) and the
      latest commit includes ARCHITECTURE.md, BUSINESS-CASE.md, and
      DEPLOYMENT.md
- [ ] Case study description above has no leftover placeholder text before
      copy-pasting into the Upwork listing
