# E-commerce Cart Recovery & Lapsed Customer Win-Back

## What this is
A production-pattern automation, not a demo toy. It's a genericized rebuild of a
renewal/re-engagement recycling system pattern (originally proven in a different
industry, resold to multiple clients there) applied to e-commerce: recovering
abandoned carts and re-engaging lapsed customers, with the same production
discipline — dry-run mode, segmentation, stop-on-conversion, and failure alerting.

## Architecture
Three independent triggers feeding one recovery/re-engagement system:

1. **Every 15 min - Scan Abandoned Carts**: pulls carts abandoned 1hr+ with fewer
   than 3 touches sent, and at least 20hrs since the last touch (spacing prevents
   spamming). Segments by cart value and touch number into 4 branches (high-value
   first touch, standard first touch, incentive second touch, final touch).
2. **Webhook: Order Placed**: fires the moment a real order lands and immediately
   marks the matching cart as converted, which removes it from future scans. This
   is the "stop annoying people who already bought" logic that's easy to skip and
   expensive to skip.
3. **Daily - Scan Lapsed Customers**: separate cadence for customers with no
   purchase in 90+ days, tiered win-back offer by lifetime value, capped so the
   same customer isn't re-touched more than once every 60 days.

## Why it's built this way (the parts that matter to a client)
- **Dry-run mode is a config flag, not a code change.** New automations should be
  provable before they touch real customers or send real emails — flip one
  boolean, review the "would-send" log, then go live.
- **Segmentation lives in the workflow, not hardcoded per-customer.** Value tier
  and touch number drive both the offer and the copy, so adding a new segment
  later is a Switch rule, not a rebuild.
- **Conversion stops the sequence immediately.** No customer gets a "come back!"
  email after they already came back. This is the single most common bug in
  cart-recovery automations built without a real order-events webhook.
- **Failures alert instead of failing silently.** An Error Trigger branch pushes
  node name, error message, and execution ID to Slack — the team finds out from
  the alert, not from a customer complaint.

## Setup
1. Import `workflow.json` into n8n.
2. Run `schema.sql` against a Postgres instance (dummy seed data included).
3. Connect your own Postgres, SMTP/email, and Slack credentials.
4. Leave `dry_run = true` in the "Config: Dry Run Flag" node for at least one full
   cycle before flipping it to `false`.

## What would change for a real client
- Cart/order source becomes a live Shopify/WooCommerce/custom-store API call
  instead of a Postgres table (Postgres here stands in for "your store's data").
- Email sending swaps to the client's ESP (Klaviyo, SendGrid, Postmark, etc.) via
  their native node or HTTP Request.
- Segmentation rules and copy get tuned to the client's actual price points and
  brand voice.
