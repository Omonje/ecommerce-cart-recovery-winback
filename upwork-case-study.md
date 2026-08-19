# Upwork Portfolio Entry (copy-paste ready, edit before posting)

**Title:** Cross-Channel Cart Recovery & Win-Back Automation (n8n + Postgres + Twilio)

**Cover image:** screenshot the n8n canvas itself, it reads as more credible
than a stock graphic. The full architecture diagram lives in
[ARCHITECTURE.md](ARCHITECTURE.md) if you want to render that instead.

**Links to include in the listing:** [ARCHITECTURE.md](ARCHITECTURE.md),
[BUSINESS-CASE.md](BUSINESS-CASE.md), [DEPLOYMENT.md](DEPLOYMENT.md) — these
three are what separate this from a workflow screenshot, they show you can
reason about a system, not just assemble nodes.

**Description:**

Built a production-grade cart recovery and customer win-back system for an
e-commerce store using n8n and PostgreSQL. If you're already on Shopify +
Klaviyo, Klaviyo's stock abandoned-cart flow covers the basics — this isn't
that. It's built for stores that aren't on that exact stack, or that need the
layer most off-the-shelf flows leave out: real-time stop-on-conversion tied
to an order webhook, a final touch that escalates to SMS instead of another
email, and lapsed-customer win-back tiered by lifetime value.

The system runs two independent automations:

1. A recovery sequence that scans for abandoned carts every 15 minutes, segments
   shoppers by cart value and how many touches they've already received, and
   sends a 3-touch escalating sequence (standard reminder → incentive offer →
   final notice by SMS) with built-in spacing so customers aren't spammed.
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

**Skills tags:** n8n, PostgreSQL, Email Automation, SMS Automation (Twilio),
CRM Integration, Marketing Automation, Workflow Automation, API Integration

**Before posting, confirm:**
- [ ] Placeholder demo branding in the workflow (`orders@northfield-outfitters-demo.com`,
      the `northfield-outfitters-demo.com` unsubscribe link domain) is either
      left as clearly-marked demo branding (fine for a portfolio piece) or
      swapped for real branding — just not silently inconsistent between
      nodes
- [ ] The Twilio "From" number and the phone value in Normalize Checkout
      Fields are real (not `+1XXXXXXXXXX`) before recording, or the SMS
      touch will visibly fail on camera
- [ ] At least one dry-run cycle has actually been run and the "would-send"
      log reviewed, not just left as a documented feature that was never
      exercised
- [ ] Loom recorded (60-90 seconds), walking through the segmentation
      logic, the stop-on-conversion webhook, and the SMS escalation +
      unsubscribe webhook specifically — that's what turns this from "a
      screenshot" into "proof you understand production systems"
- [ ] Repo is public (or the listing links a private repo invite) and the
      latest commit includes ARCHITECTURE.md, BUSINESS-CASE.md, and
      DEPLOYMENT.md
- [ ] Case study description above has no leftover placeholder text before
      copy-pasting into the Upwork listing
