import json
import sys
import getopt

arg_input = "input.json"
arg_output = "output.json"

opts, args = getopt.getopt(sys.argv[1:], "i:o:", ["input=", "output="])

for opt, arg in opts:
    if opt in ("-i", "--input"):
        arg_input = arg
        # Update output file path
        path = arg.split('/')
        del path[-1]
        path = '/'.join(map(str,path)) + '/'
        arg_output = path + arg_output
    elif opt in ("-o", "--output"):
        path = arg_input.split('/')
        del path[-1]
        path = '/'.join(map(str,path)) + '/'
        arg_output = path + arg

print("Input file: " + arg_input)
print("Output file: " + arg_output)

# Load JSON file
with open(arg_input, 'r') as file:
    data = json.load(file)

# Remove primary keys
data = list(data.values())

# Save the converted JSON as an array of objects
with open(arg_output, 'w') as file:
    json.dump(data, file)

print("JSON dictionary converted to an array of objects.")