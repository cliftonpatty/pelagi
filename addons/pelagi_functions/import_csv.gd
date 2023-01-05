@tool
extends EditorPlugin

# Declare variables for the CSV and BaseData resource
var csv
var base_data
var id 

func load_assnd_write():
	# Load the CSV and BaseData resource
	csv = load("res://csv/drillables/drillables.csv")
	base_data = load("res://BaseData.tres")

	# Iterate through the rows in the CSV, excluding the first row
	#for i in range(1, csv.get_row_count()):
		# Get the ID from the first column of the current row
	#	id = csv.get_cell(i, 0)

	# Set the variables in the BaseData resource based on the values in the remaining columns of the current row
	#for j in range(1, csv.get_column_count()):
		# Get the variable name from the first row of the CSV
	#	var variable_name = csv.get_cell(0, j)
		# Get the value from the current row and column
	#	var value = csv.get_cell(i, j)

		# Set the variable in the BaseData resource
	#	base_data[variable_name] = value

		# Print the variable name and value
	#	print(variable_name + ": " + str(value))
	#for i in range(1, csv()):
		#print(i)
	# Unload the CSV
	csv = null
#
static func load_and_write():
	var delim: String = ","
	var file = FileAccess.open("res://csv/drillables/drillables.csv", FileAccess.READ)
	var lines = []
	while not file.eof_reached():
		var line = file.get_csv_line(delim)
		var detected := []
		for field in line:
			if field.is_valid_int():
				detected.append(int(field))
			else:
				detected.append(field)
		lines.append(detected)
	file = null 

	# Remove trailing empty line
	if not lines.is_empty() and lines.back().size() == 1 and lines.back()[0] == "":
		lines.pop_back()

	var data = preload("csv_data.gd").new()
	
	if lines.is_empty():
		printerr("Can't find header in empty file")
		return ERR_PARSE_ERROR
	
	var headers = lines[0]
	for i in range(1, lines.size()):
		var fields = lines[i]
		if fields.size() > headers.size():
			printerr("Line %d has more fields than headers" % i)
			return ERR_PARSE_ERROR
		var dict = {}
		for j in headers.size():
			var name = headers[j]
			var value = fields[j] if j < fields.size() and str(fields[j]) != 'null' else null
			if name.contains('loot') and value:
				value = parse_loot(value)
			dict[name] = value
		data.records.append(dict)
		print(dict)
	
	#var filename = save_path + "." + get_save_extension()
	#err = ResourceSaver.save(filename, data)
	#if err != OK:
	#	printerr("Failed to save resource: ", err)
	#return err

static func parse_loot(loot : String):
	var split_loot : PackedStringArray = loot.split(",", true, 0)
	var result : Dictionary = {}
	for item in split_loot:
		if result.has(item):
			result[item] += 1
		else:
			result[item] = 1
	return result
