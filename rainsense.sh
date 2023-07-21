#!/bin/bash

# API call: change latitude & longitude depending on your location
url="https://api.open-meteo.com/v1/forecast?latitude=45.5088&longitude=-73.5878&timezone=EST&hourly=precipitation&past_days=1"
response=$(curl -s "$url")

# check API call
if [[ $? -eq 0 ]]; then
    # Save the JSON response in a file named "data.json"
    echo "$response" > "data.json"
    echo $(date +"%Y-%m-%dT%H:%M:%S")"-The data.json file has been created successfully."
else
    echo "The API request failed."
    exit 1
fi

# Load JSON data from the file
readarray -t times < <(jq -r '.hourly.time[]' data.json)
readarray -t precipitations < <(jq -r '.hourly.precipitation[]' data.json)

# Get the current date and time in the format YYYY-MM-DDTHH:00
now=$(date +"%Y-%m-%dT%H:00")

# Find the index corresponding to the current date and time
current_index=-1
for i in "${!times[@]}"; do
    if [[ "${times[$i]}" == "$now" ]]; then
        current_index=$i
        break
    fi
done

if [[ $current_index -eq -1 ]]; then
    echo $(date +"%Y-%m-%dT%H:%M:%S")"-Unable to find the index for the current hour."
    exit 1
fi

# Extract the last 24 hours of precipitation values
start_index=$((current_index - 23))
end_index=$current_index

if [[ $start_index -lt 0 ]]; then
    start_index=0
fi

last_24_hours_precipitations=()
for ((i=start_index; i<=end_index; i++)); do
    last_24_hours_precipitations+=("${precipitations[$i]}")
done

echo $(date +"%Y-%m-%dT%H:%M:%S")"-Last 24 hours: ${last_24_hours_precipitations[@]}"
echo $(date +"%Y-%m-%dT%H:%M:%S")"-Current Index: $current_index"

# Calculate the average precipitation value over the last 24 hours
average_precipitation=0
for value in "${last_24_hours_precipitations[@]}"; do
    average_precipitation=$(echo "$average_precipitation + $value" | bc)
done
average_precipitation=$(echo "scale=2; $average_precipitation / ${#last_24_hours_precipitations[@]}" | bc)

echo $(date +"%Y-%m-%dT%H:%M:%S")"-Average precipitation over the last 24 hours: $average_precipitation"

# Check if precipitation is less than or equal to 0.2
if (( $(echo "$average_precipitation -eq 0" | bc -l) )); then
    # Execute the "kasa on" command
    echo $(date +"%Y-%m-%dT%H:%M:%S")"-Turn on for 30 seconds."
    kasa --type strip --host 192.168.1.1 on --name Watering  #Replace host IP & name by yours
    # Wait for 30 seconds
    sleep 30
    # Execute the "kasa off" command
    echo $(date +"%Y-%m-%dT%H:%M:%S")"-Turn off for 60 seconds."
    kasa --type strip --host 192.168.1.1 off --name Watering  #Replace host IP & name by yours
else
    state="Remain off."
    echo $(date +"%Y-%m-%dT%H:00")"-Precipitation is greater than 0. Do nothing."
fi

