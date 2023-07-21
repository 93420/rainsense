<a href="https://imgbb.com/"><img src="https://i.ibb.co/DzS4sgM/rainsense.png" alt="rainsense" border="0"></a><br>

## Title: Automated Control of Smart Plug Based on Precipitation Forecast

**Description:**\
The *"Automated Control of Smart Plug Based on Precipitation Forecast"* script is a practical tool to automate the management of electrical devices based on weather forecasts. This script uses a weather API to retrieve hourly precipitation data for a specific location and utilizes this information to control a Kasa smart plug. -> [Supported Devices](https://github.com/python-kasa/python-kasa#supported-devices).

**How the script works:**

1\. **Obtaining Weather Data:**\
   - The script starts by making an API request to fetch weather forecast data, based on the latitude and longitude of a defined location. The retrieved weather information includes hourly precipitation values over a 24-hour period. The weather forecast data is saved in a JSON file named "data.json." This file serves as a reference for the script's future actions.

2\. **Calculating Average Precipitation:**\
   - The script determines the current date and time in the format "YYYY-MM-DDTHH:<b>00</b>" and looks up the corresponding index in the weather data. It then extracts the precipitation values for the last 24 hours, centered around the current time. Using this data, the script calculates the average precipitation over this period.

3\. **Smart Plug Control:**\
   - The script compares the average precipitation with a predefined threshold (0 in this case). If the average is equal to the threshold, indicating a low probability of precipitation, the script takes action. It commands a smart plug to turn on a device for 30 seconds, and it turns the device off.

By using this script, you can automate the operation of electrical devices based on weather conditions, providing a convenient and energy-efficient way to respond to precipitation forecasts and optimize the usage of your electrical appliances.
