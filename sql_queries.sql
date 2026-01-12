--1. Create 4 tables for each event and import CSV files into the tables.
CREATE TABLE visits (
    user_id UUID PRIMARY KEY,
    visit_time TIMESTAMP
);

CREATE TABLE cart (
    user_id UUID,
    visit_time TIMESTAMP,
	FOREIGN KEY(user_id) REFERENCES visits(user_id)
);

CREATE TABLE checkout (
    user_id UUID,
    visit_time TIMESTAMP,
	FOREIGN KEY(user_id) REFERENCES visits(user_id)
);

CREATE TABLE purchase (
    user_id UUID,
    visit_time TIMESTAMP,
	FOREIGN KEY(user_id) REFERENCES visits(user_id)
);

--2. Rename timestamp column to its respective event time.
ALTER TABLE checkout 
RENAME COLUMN visit_time TO checkout_time;

ALTER TABLE cart 
RENAME COLUMN visit_time TO cart_time;

ALTER TABLE purchase 
RENAME COLUMN visit_time TO purchase_time;

--3. Create an events table. 
CREATE TABLE events(
	user_id UUID,
	event_time TIMESTAMP,
	event_type TEXT
);

--4. Combine all 4 tables into events table.
INSERT INTO events(user_id, event_time, event_type)
SELECT user_id, visit_time, 'visit' FROM visits
UNION ALL
SELECT user_id, checkout_time, 'checkout' FROM checkout
UNION ALL
SELECT user_id, cart_time, 'cart' FROM cart
UNION ALL
SELECT user_id, purchase_time, 'purchase' FROM purchase;

--5. Build a funnel view that shows when each user passed through each stage (visit → cart → checkout → purchase), all in one row per user.
CERATE VIEW funnel AS(
	SELECT user_id,
	MIN(CASE WHEN event_type = 'visit' THEN event_time END) AS visit_time,
	MIN(CASE WHEN event_type = 'cart' THEN event_time END) AS cart_time,
	MIN(CASE WHEN event_type = 'checkout' THEN event_time END) AS checkout_time,
	MIN(CASE WHEN event_type = 'purchase' THEN event_time END) AS purchase_time
 	FROM events 
 	GROUP BY user_id 
)
SELECT *
FROM funnel;

--6. Calculate number of users who reached each event stage. 
SELECT 
COUNT(*) AS total_users,
COUNT(CASE WHEN visit_time IS NOT NULL THEN user_id END) AS visit_count,
COUNT(CASE WHEN cart_time IS NOT NULL THEN user_id END) AS cart_count,
COUNT(CASE WHEN checkout_time IS NOT NULL THEN user_id END) AS checkout_count,
COUNT(CASE WHEN purchase_time IS NOT NULL THEN user_id END) AS purchase_count
FROM funnel;

--7. How many users abandoned after cart?
SELECT 
COUNT(*) AS cart_abandoners
FROM funnel
WHERE cart_time IS NOT NULL
  AND purchase_time IS NULL
FROM funnel;

--8. Are there users who skipped funnel steps?
SELECT 
COUNT(*) AS users_who_skipped_steps
FROM funnel
WHERE
    (cart_time IS NOT NULL AND visit_time IS NULL)
 OR (checkout_time IS NOT NULL AND cart_time IS NULL)
 OR (purchase_time IS NOT NULL AND checkout_time IS NULL);

--9. Calculate conversion rates
SELECT
ROUND(COUNT(cart_time) * 100 / COUNT(visit_time), 2) AS visit_to_cart_rate,
ROUND(COUNT(checkout_time) * 100 / COUNT(cart_time), 2) AS cart_to_checkout_rate,
ROUND(COUNT(purchase_time) * 100 / COUNT(checkout_time), 2) AS checkout_to_purchase_rate
FROM funnel;

--10. Calculate drop-off rates
SELECT
ROUND(100 -(COUNT(cart_time) * 100 / COUNT(visit_time)), 2) AS visit_to_cart_dropoff,
ROUND(100 - (COUNT(checkout_time) * 100 / COUNT(cart_time)), 2) AS cart_to_checkout_dropoff,
ROUND(100 - (COUNT(purchase_time) * 100 / COUNT(checkout_time)), 2) AS checkout_to_purchase_dropoff
FROM funnel;












