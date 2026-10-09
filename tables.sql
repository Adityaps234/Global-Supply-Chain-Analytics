-- 1. Bulletproof Shipping Rates
CREATE TABLE shipping_rates (
    date TEXT,
    year TEXT,
    month TEXT,
    baltic_dry_index TEXT,
    container_rate_usd_40ft TEXT,
    air_cargo_rate_usd_kg TEXT,
    bdi_mom_change_pct TEXT,
    container_yoy_pct TEXT,
    tanker_rate_aframax_usd_day TEXT,
    bulk_carrier_handysize_usd_day TEXT,
    supply_chain_pressure_index TEXT,
    on_time_delivery_pct TEXT
);

-- 2. Bulletproof Port Congestion
CREATE TABLE port_congestion (
    week_start TEXT,
    year TEXT,
    port TEXT,
    country TEXT,
    region TEXT,
    throughput_teu_mn TEXT,
    vessels_at_anchor TEXT,
    avg_wait_days TEXT,
    congestion_index TEXT,
    port_utilization_pct TEXT,
    berth_delay_hrs TEXT
);

-- 3. Bulletproof Disruption Events
CREATE TABLE disruption_events (
    date TEXT,
    year TEXT,
    event_name TEXT,
    disruption_type TEXT,
    region_affected TEXT,
    duration_days TEXT,
    bdi_shock_pct TEXT,
    freight_rate_shock_pct TEXT,
    severity TEXT,
    gdp_impact_pct TEXT,
    trade_volume_impact_pct TEXT,
    recovery_months TEXT,
    is_pandemic TEXT,
    is_geopolitical TEXT,
    is_natural TEXT,
    is_financial TEXT,
    straits_affected TEXT,
    port_closure TEXT
);

-- 4. Bulletproof Commodity Prices
CREATE TABLE commodity_prices (
    date TEXT,
    year TEXT,
    month TEXT,
    commodity TEXT,
    category TEXT,
    unit TEXT,
    currency TEXT,
    price TEXT
);