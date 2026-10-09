-- 1. Top 10 Global Ports with wrost Delays

/*SELECT 
    port, 
    country, 
    ROUND(AVG(CAST(avg_wait_days AS NUMERIC)), 2) AS average_wait_days
FROM port_congestion
GROUP BY port, country
ORDER BY average_wait_days DESC
LIMIT 10;*/

-- 2. Top 10 global events caused the biggest spike in shipping costs

/*SELECT 
    event_name, 
    disruption_type, 
    severity,
    CAST(freight_rate_shock_pct AS NUMERIC) AS freight_cost_spike_percentage
FROM disruption_events
ORDER BY CAST(freight_rate_shock_pct AS NUMERIC) DESC
LIMIT 10;*/

--3. When was it the most expensive to export goods?

/*SELECT 
    year, 
    MAX(CAST(container_rate_usd_40ft AS NUMERIC)) AS peak_container_cost_usd
FROM shipping_rates
GROUP BY year
ORDER BY peak_container_cost_usd DESC
LIMIT 5;*/

-- 4. Which commodities have the highest average market price

/*SELECT 
    commodity, 
    category,
    ROUND(AVG(CAST(price AS NUMERIC)), 2) AS average_price
FROM commodity_prices
GROUP BY commodity, category
ORDER BY average_price DESC
LIMIT 10;*/

-- 5. Calculate a rolling 3-month average for container shipping rates to smooth out volatile price spikes.

/*SELECT 
    year, 
    month, 
    CAST(container_rate_usd_40ft AS NUMERIC) AS current_container_rate,
    ROUND(AVG(CAST(container_rate_usd_40ft AS NUMERIC)) OVER (
        ORDER BY year, month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3_month_avg_rate
FROM shipping_rates;*/

-- 6. Join tables to see the maximum container shipping rate during major global disruptions.

/*SELECT 
    d.year,
    d.event_name,
    d.disruption_type,
    MAX(CAST(s.container_rate_usd_40ft AS NUMERIC)) AS max_container_rate_usd
FROM disruption_events d
JOIN shipping_rates s ON d.year = s.year
GROUP BY d.year, d.event_name, d.disruption_type
ORDER BY max_container_rate_usd DESC;*/

-- 7. Calculate price volatility (Max Price vs Min Price) for commodities to assess market risk.

/*WITH CommodityStats AS (
    SELECT 
        commodity,
        category,
        MAX(CAST(price AS NUMERIC)) AS max_price,
        MIN(CAST(price AS NUMERIC)) AS min_price,
        AVG(CAST(price AS NUMERIC)) AS avg_price
    FROM commodity_prices
    GROUP BY commodity, category
)
SELECT 
    commodity,
    category,
    (max_price - min_price) AS price_volatility,
    ROUND(avg_price, 2) AS average_price
FROM CommodityStats
ORDER BY price_volatility DESC
LIMIT 15;*/

-- 8. Port Congestion Risk Levels

/*SELECT 
    port,
    country,
    ROUND(AVG(CAST(vessels_at_anchor AS NUMERIC)), 0) AS avg_vessels_waiting,
    CASE 
        WHEN AVG(CAST(vessels_at_anchor AS NUMERIC)) >= 50 THEN 'Critical Congestion'
        WHEN AVG(CAST(vessels_at_anchor AS NUMERIC)) >= 20 THEN 'Moderate Delay'
        ELSE 'Normal Flow' 
    END AS congestion_risk_level
FROM port_congestion
WHERE port != '0'
GROUP BY port, country
ORDER BY avg_vessels_waiting DESC
LIMIT 15;*/

-- 9. Year-Over-year Freight Cost Spikes 

/*WITH YearlyRates AS (
    SELECT 
        year,
        AVG(CAST(container_rate_usd_40ft AS NUMERIC)) AS avg_container_rate
    FROM shipping_rates
    WHERE year != '0'
    GROUP BY year
)
SELECT 
    year,
    ROUND(avg_container_rate, 2) AS current_year_rate,
    ROUND(LAG(avg_container_rate) OVER (ORDER BY year), 2) AS previous_year_rate,
    ROUND(((avg_container_rate - LAG(avg_container_rate) OVER (ORDER BY year)) / 
    NULLIF(LAG(avg_container_rate) OVER (ORDER BY year), 0)) * 100, 2) AS yoy_cost_increase_pct
FROM YearlyRates;*/

-- 10. Disruption Impact and recōvery Time

/*SELECT 
    region_affected,
    COUNT(event_name) AS total_disruption_events,
    ROUND(AVG(CAST(recovery_months AS NUMERIC)), 1) AS avg_months_to_recover,
    ROUND(AVG(CAST(trade_volume_impact_pct AS NUMERIC)), 2) AS avg_trade_volume_loss_pct
FROM disruption_events
WHERE region_affected != '0' 
GROUP BY region_affected
ORDER BY total_disruption_events DESC;*/

-- 11. Peak Pricing Years by Commodity Category

/*WITH RankedCommodities AS (
    SELECT 
        year,
        category,
        ROUND(AVG(CAST(price AS NUMERIC)), 2) AS avg_yearly_price,
        RANK() OVER(PARTITION BY category ORDER BY AVG(CAST(price AS NUMERIC)) DESC) as price_rank
    FROM commodity_prices
    WHERE category != '0'
    GROUP BY year, category
)
SELECT 
    category,
    year AS most_expensive_year,
    avg_yearly_price
FROM RankedCommodities
WHERE price_rank = 1;*/