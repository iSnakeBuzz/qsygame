class_name KeyManager

var key_mappings: Dictionary[String, KeyMapping] = {}

func _init(resource: String) -> void:
	var parser = XMLParser.new()
	var error = parser.open(resource)
	
	if error != OK:
		print("Error opening XML file: ", resource)
		return
	
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			
			if node_name == "sprite":
				# Extract attributes from SubTexture element
				var name = parser.get_named_attribute_value_safe("n")
				var x = parser.get_named_attribute_value_safe("x").to_int()
				var y = parser.get_named_attribute_value_safe("y").to_int()
				var width = parser.get_named_attribute_value_safe("w").to_int()
				var height = parser.get_named_attribute_value_safe("h").to_int()
				
				# Create KeyMapping object and add to dictionary
				var key_mapping = KeyMapping.new(name, x, y, width, height)
				key_mappings[name] = key_mapping

func get_key_mapping(name: String) -> KeyMapping:
	if key_mappings.has(name):
		return key_mappings[name]
	else:
		print("KeyMapping not found: ", name)
		return null

func get_all_mappings() -> Dictionary[String, KeyMapping]:
	return key_mappings
