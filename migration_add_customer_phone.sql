-- Run this once against the `portfolio` database (pgAdmin Query Tool)
-- Adds the phone column needed for the final-touch SMS escalation (Twilio).

ALTER TABLE carts ADD COLUMN IF NOT EXISTS customer_phone VARCHAR(20);
