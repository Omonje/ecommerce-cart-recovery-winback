# Architecture

Three independent triggers feed one recovery/win-back system, sharing the
`carts` and `customers` tables as shared state. See [README.md](README.md)
for setup and troubleshooting.

```mermaid
flowchart TD
    subgraph Recovery["1. Cart Recovery — every 15 min"]
        A1[Schedule: every 15 min] --> A2[Shopify GraphQL: Get Checkouts]
        A2 --> A3[Normalize fields + Filter: has email]
        A3 --> A4[(Postgres: upsert cart row)]
        A4 --> A5[(Postgres: get eligible carts)]
        A5 --> A6{Dry run?}
        A6 -->|yes| A7[Log would-send, no email sent]
        A6 -->|no| A8{Segment: value tier x touch #}
        A8 --> A9[Build message copy]
        A9 --> A10[Send recovery email]
        A10 --> A11[(Postgres: log touch, increment count)]
    end

    subgraph Conversion["2. Stop-on-Conversion"]
        B1((Webhook: order placed)) --> B2[(Postgres: mark cart converted)]
    end

    subgraph Winback["3. Lapsed Win-Back — daily"]
        C1[Schedule: daily 9am] --> C2[(Postgres: get customers inactive 90+ days)]
        C2 --> C3{Valid email, not unsubscribed?}
        C3 -->|yes| C4[Build tiered offer by LTV]
        C4 --> C5[Send win-back email]
        C5 --> C6[(Postgres: log win-back touch)]
    end

    subgraph Errors["Error Alerting — always on"]
        D1((Error Trigger, any branch)) --> D2[Slack: alert with node, error, execution ID]
    end

    A4 -.same carts table.-> B2
```

## Why three separate triggers instead of one workflow

Each branch has a different cadence and a different failure mode, so they run
independently rather than being chained:

- **Cart Recovery (15 min)** needs to run often enough to catch a fresh
  abandonment, but is gated by its own spacing rules (`touch_count < 3`,
  20hrs+ since last touch) so frequency doesn't equal spam.
- **Stop-on-Conversion (webhook)** has to react in real time, the moment an
  order lands, not on the next 15-minute poll. Coupling it to the scan
  cadence would leave a window where a converted customer still gets a
  recovery email.
- **Lapsed Win-Back (daily)** operates on a completely different signal
  (90+ days of inactivity) and a completely different table relationship
  (`customers`, not `carts`). Bundling it into the cart-recovery scan would
  mean one bug in either logic path risks breaking both.

## Shared state, not shared logic

The `carts` table is the single source of truth both the recovery scan and
the conversion webhook read/write against. That's what makes
stop-on-conversion reliable, the webhook doesn't need to know anything about
segmentation or touch counts, it just flips `status = 'converted'` and the
next scan's `WHERE status = 'abandoned'` clause naturally excludes that row.
