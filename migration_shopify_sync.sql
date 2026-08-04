-- Run this once against the `portfolio` database (pgAdmin Query Tool)
-- Adds the column that links a tracked cart row to a real Shopify checkout.

ALTER TABLE carts ADD COLUMN IF NOT EXISTS shopify_checkout_id VARCHAR(100) UNIQUE;
