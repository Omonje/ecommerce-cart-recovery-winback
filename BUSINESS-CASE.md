# Business Case

## Problem

Cart abandonment is the single largest source of recoverable lost revenue in
e-commerce. Baymard Institute's running average across 59 studies puts
abandonment at **70.22%** of all carts, meaning roughly 7 in 10 shoppers who
add an item never complete the purchase ([Baymard Institute](https://baymard.com/lists/cart-abandonment-rate)).

Most stores respond with either nothing, or a single generic "did you forget
something?" email. That leaves value on the table in two specific ways:

1. **No segmentation.** A $15 cart and a $1,500 cart get the same message, so
   the offer that would convert the high-value shopper (urgency, no discount
   needed) is wasted on everyone, and the offer that would convert the
   price-sensitive shopper (a real incentive) never gets sent.
2. **No stop condition.** Without a real-time signal that an order landed,
   recovery sequences keep emailing customers who already bought, which is
   one of the fastest ways to make an automated system feel broken to a
   customer, and to a client evaluating whether to trust automation at all.

There's a second, quieter leak: customers who bought once and never came
back. Most stores have no systematic re-engagement for this segment at all,
it's treated as churn rather than a recoverable audience.

## Solution

This system addresses both problems directly, described in full in
[ARCHITECTURE.md](ARCHITECTURE.md):

- **Segmentation by cart value and touch number** drives both the offer and
  the copy, a high-value first touch gets urgency messaging with no
  discount, later touches escalate to an incentive, so margin isn't given
  away on shoppers who would have converted anyway.
- **A real order-events webhook stops the sequence within one poll cycle of
  a real purchase**, not on the next scheduled scan. This is the detail most
  cart-recovery builds skip, and it's usually the first thing that erodes a
  client's trust in an automated system.
- **A separate lapsed-customer win-back** treats post-purchase churn as its
  own recoverable segment, tiered by lifetime value rather than a flat offer
  to everyone.
- **Dry-run mode** means the entire system, including segmentation and
  message selection, can be verified against real data before a single real
  email goes out. That's the difference between "trust me, it works" and a
  client being able to review exactly what would have been sent.

## Who this is for

Any store past the point of manual follow-up (roughly $5k+/month GMV) that
either has no cart recovery in place, or has one that's a single generic
email with no segmentation and no stop-on-conversion logic, the two gaps
most off-the-shelf abandoned-cart apps still leave open.

## Expected impact

This is a portfolio build, not a live client deployment, so there's no real
production data to report here. What follows is industry benchmark data,
not a guaranteed or achieved result for this specific implementation:

- Across a large abandoned-cart benchmark dataset, cart recovery emails
  convert at roughly **3.3% placed-order rate on average**, with elite
  performers reaching **7.7%+** through segmentation and offer tuning like
  this system implements ([Metorik cart abandonment benchmarks](https://metorik.com/blog/cart-abandonment-rate-benchmarks)).
- A well-executed recovery sequence is generally expected to land in the
  **10-15% recovery rate range**, with up to **20% of abandonments**
  considered recoverable industry-wide ([Mailmend cart abandonment recovery statistics](https://mailmend.io/blogs/cart-abandonment-recovery-statistics)).
- At the $260B/year industry-wide scale of recoverable abandoned-cart
  revenue cited by the same benchmark data, even a store converting at the
  low end of that range represents a meaningful, directly attributable
  revenue line, not a marginal optimization.

The honest framing for a prospective client: this system is built to
capture the segmentation and stop-on-conversion gaps that most off-the-shelf
tools leave on the table, actual recovery rate depends on the store's price
points, audience, and email deliverability, and should be measured against
that store's own baseline once live.

