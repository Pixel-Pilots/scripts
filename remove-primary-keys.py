import json

# Load JSON file
with open('currencies.json', 'r') as file:
    data = json.load(file)

# Remove primary keys
data = list(data.values())

# Save the converted JSON as an array of objects
with open('output.json', 'w') as file:
    json.dump(data, file)

print("JSON dictionary converted to an array of objects.")