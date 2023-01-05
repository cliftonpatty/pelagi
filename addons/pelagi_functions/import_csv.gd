@tool
extends EditorPlugin

# Declare variables for the CSV and BaseData resource
var csv
var base_data
var id 

func _ready():
	# Load the CSV and BaseData resource
	csv = load("path/to/csv.csv")
	base_data = load("res://BaseData.tres")

	# Iterate through the rows in the CSV, excluding the first row
	for i in range(1, csv.get_row_count()):
		# Get the ID from the first column of the current row
		id = csv.get_cell(i, 0)

	# Set the variables in the BaseData resource based on the values in the remaining columns of the current row
	for j in range(1, csv.get_column_count()):
		# Get the variable name from the first row of the CSV
		var variable_name = csv.get_cell(0, j)
		# Get the value from the current row and column
		var value = csv.get_cell(i, j)

		# Set the variable in the BaseData resource
		base_data[variable_name] = value

		# Print the variable name and value
		print(variable_name + ": " + str(value))

	# Unload the CSV
	unload(csv)

