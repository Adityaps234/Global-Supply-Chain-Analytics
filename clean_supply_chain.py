import pandas as pd

# 1. Read the 4 files into Python
shipping = pd.read_csv('shipping_rates.csv')
ports = pd.read_csv('port_congestion.csv')
events = pd.read_csv('disruption_events.csv')
commodities = pd.read_csv('commodity_prices_supply_chain.csv')

# 2. Clean the data: Replace any blank, missing spaces with the number 0
# This ensures our SQL database handles the 110,000+ rows smoothly!
shipping = shipping.fillna(0)
ports = ports.fillna(0)
events = events.fillna(0)
commodities = commodities.fillna(0)

# 3. Save our new Cleaned Files so we can use them in SQL next
shipping.to_csv('Clean_Shipping.csv', index=False)
ports.to_csv('Clean_Ports.csv', index=False)
events.to_csv('Clean_Disruptions.csv', index=False)
commodities.to_csv('Clean_Commodities.csv', index=False)

print("Success! Your 4 core supply chain files are cleaned and ready for SQL!")