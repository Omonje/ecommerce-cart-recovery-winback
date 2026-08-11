-- Demo schema for Cart Recovery & Win-Back workflow
-- Dummy data only - no real customer/store information

CREATE TABLE carts (
    id SERIAL PRIMARY KEY,
    customer_email VARCHAR(255) NOT NULL,
    cart_value NUMERIC(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    status VARCHAR(20) DEFAULT 'abandoned', -- abandoned | converted
    order_id VARCHAR(50),
    touch_count INT DEFAULT 0,
    last_touch_at TIMESTAMP,
    last_template VARCHAR(100),
    is_first_time_customer BOOLEAN DEFAULT true,
    unsubscribed BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    customer_email VARCHAR(255) UNIQUE NOT NULL,
    lifetime_value NUMERIC(10,2) DEFAULT 0,
    favorite_category VARCHAR(100),
    last_order_at TIMESTAMP,
    last_winback_sent_at TIMESTAMP,
    unsubscribed BOOLEAN DEFAULT false
);

-- Sample seed data (fictional)
INSERT INTO carts (customer_email, cart_value, is_first_time_customer, updated_at) VALUES
('demo.buyer1@example.com', 210.00, true, NOW() - INTERVAL '2 hours'),
('demo.buyer2@example.com', 45.50, false, NOW() - INTERVAL '3 hours'),
('demo.buyer3@example.com', 89.00, true, NOW() - INTERVAL '25 hours');

INSERT INTO customers (customer_email, lifetime_value, favorite_category, last_order_at) VALUES
('demo.lapsed1@example.com', 620.00, 'Outdoor Gear', NOW() - INTERVAL '95 days'),
('demo.lapsed2@example.com', 180.00, 'Home Decor', NOW() - INTERVAL '120 days');

