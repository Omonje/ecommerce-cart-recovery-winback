# Upwork Portfolio Entry (copy-paste ready, edit before posting)

**Title:** E-commerce Cart Recovery & Customer Win-Back Automation (n8n)

**Cover image suggestion:** simple architecture diagram — 3 boxes (Cart Scan →
Segment & Send → Log/Stop-on-Convert) plus a side box for the daily win-back scan.
Screenshot the n8n canvas itself; it reads as more credible than a stock graphic.

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

**Note before posting:** replace the placeholder store name/emails in the
workflow with your own demo branding, and consider recording a 60-90 second
Loom walking through the n8n canvas — talking through the segmentation logic and
the stop-on-conversion webhook is what turns this from "a screenshot" into "proof
you understand production systems."
