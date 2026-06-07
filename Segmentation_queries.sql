CREATE DATABASE d2c_retention;
USE d2c_retention;

CREATE TABLE customers (
    customer_id INT,
    age INT,
    gender VARCHAR(10),
    item_purchased VARCHAR(50),
    category VARCHAR(50),
    purchase_amount INT,
    location VARCHAR(50),
    size VARCHAR(5),
    color VARCHAR(20),
    season VARCHAR(10),
    review_rating FLOAT,
    subscription_status VARCHAR(5),
    shipping_type VARCHAR(20),
    discount_applied VARCHAR(5),
    previous_purchases INT,
    payment_method VARCHAR(20),
    frequency_of_purchases VARCHAR(20),
    frequency_score INT,
    amount_normalized FLOAT,
    purchases_normalized FLOAT,
    value_score FLOAT,
    value_tier VARCHAR(20),
    purchases_freq_normalized FLOAT,
    loyalty_score_a FLOAT,
    loyalty_score_b FLOAT,
    promo_dependency_score INT,
    satisfaction_flag VARCHAR(15),
    loyalty_tier VARCHAR(20)
);


SELECT COUNT(*) as total_rows FROM customers;
SELECT * FROM customers LIMIT 5;

-- ============================================================
-- QUERY 1: Loyal vs Discount-Dependent Customers
-- Business Question: Who are genuinely loyal customers vs
-- those who only buy when there is a discount?
-- Segments customers by loyalty tier and promo dependency
-- to surface behavioural differences between groups.
-- ============================================================

SELECT 
    loyalty_tier,
    promo_dependency_score,
    COUNT(*) AS customer_count,
    ROUND(AVG(previous_purchases), 1) AS avg_previous_purchases,
    ROUND(AVG(purchase_amount), 1) AS avg_spend,
    ROUND(AVG(frequency_score), 2) AS avg_frequency,
    ROUND(AVG(review_rating), 2) AS avg_rating
FROM customers
GROUP BY loyalty_tier, promo_dependency_score
ORDER BY loyalty_tier, promo_dependency_score;


-- ============================================================
-- QUERY 2: Behavioural Patterns That Predict High Customer Value
-- Business Question: What behavioural patterns today predict
-- high customer value over time?
-- Looks at how frequency, satisfaction, and subscription
-- behaviour vary across value tiers.
-- ============================================================

SELECT
    value_tier,
    COUNT(*) AS customer_count,
    ROUND(AVG(previous_purchases), 1) AS avg_previous_purchases,
    ROUND(AVG(purchase_amount), 1) AS avg_spend,
    ROUND(AVG(frequency_score), 2) AS avg_frequency,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    SUM(CASE WHEN satisfaction_flag = 'Satisfied' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(AVG(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100, 1) AS pct_discounted
FROM customers
GROUP BY value_tier
ORDER BY value_tier;

-- ============================================================
-- QUERY 3: Geographic Opportunity Analysis
-- Business Question: Which geographies are commercially
-- underlevered — high spend and low promo dependency,
-- indicating genuine brand pull rather than discount demand?
-- ============================================================

SELECT
    location,
    COUNT(*) AS customer_count,
    ROUND(AVG(purchase_amount), 1) AS avg_spend,
    ROUND(AVG(previous_purchases), 1) AS avg_purchases,
    ROUND(AVG(promo_dependency_score), 2) AS avg_promo_dependency,
    ROUND(AVG(loyalty_score_b), 3) AS avg_loyalty,
    SUM(CASE WHEN loyalty_tier = 'High Loyalty' THEN 1 ELSE 0 END) AS high_loyalty_count
FROM customers
GROUP BY location
ORDER BY avg_spend DESC, avg_promo_dependency ASC
LIMIT 15;

-- ============================================================
-- QUERY 4: Promotional Strategy Analysis
-- Business Question: How should the brand restructure its
-- promotional strategy to protect margins without losing volume?
-- Identifies which segments are safe to deprioritise discounts
-- and which segments would likely shrink without them.
-- ============================================================

SELECT
    loyalty_tier,
    discount_applied,
    COUNT(*) AS customer_count,
    ROUND(AVG(purchase_amount), 1) AS avg_spend,
    ROUND(AVG(previous_purchases), 1) AS avg_purchases,
    ROUND(AVG(frequency_score), 2) AS avg_frequency,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY loyalty_tier), 1) AS pct_within_tier
FROM customers
GROUP BY loyalty_tier, discount_applied
ORDER BY loyalty_tier, discount_applied;

-- ============================================================
-- QUERY 5: Ideal Customer Profile
-- Business Question: What does the brand's most valuable
-- customer look like, and how can it acquire more of them?
-- Profiles the top customer segment across all dimensions --
-- demographics, behaviour, category, payment, and geography.
-- ============================================================

SELECT
    gender,
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '61+'
    END AS age_group,
    category,
    payment_method,
    frequency_of_purchases,
    subscription_status,
    COUNT(*) AS customer_count,
    ROUND(AVG(purchase_amount), 1) AS avg_spend,
    ROUND(AVG(previous_purchases), 1) AS avg_purchases,
    ROUND(AVG(loyalty_score_b), 3) AS avg_loyalty
FROM customers
WHERE loyalty_tier = 'High Loyalty'
AND value_tier = 'High Value'
AND promo_dependency_score = 0
GROUP BY gender, age_group, category, payment_method, frequency_of_purchases, subscription_status
ORDER BY customer_count DESC
LIMIT 15;



