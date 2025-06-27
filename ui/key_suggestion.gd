@tool
class_name KeySuggestion
extends PanelContainer

enum DeviceType {
	KEYBOARD,
	XBOX,
	STEAM_DECK
}

@onready var exampleText = """[color={text_color}][font_size={text_size}]{text}[/font_size][/color]"""

@onready var rich_text_label: RichTextLabel = $CenterContainer/HBoxContainer/RichTextLabel
@onready var icon_rect: TextureRect = $CenterContainer/HBoxContainer/IconRect
@onready var hbox_container: HBoxContainer = $CenterContainer/HBoxContainer
@onready var margin_box: MarginContainer = $CenterContainer

@export var text: String = "":
	set(value):
		text = value
		_update_text_label()
@export var ui_key: String = ""

@export_category("Text Settings")
@export var icon_scale_ratio: float = 1.40:
	set(value):
		icon_scale_ratio = value
		_update_text_label()
@export_range(12, 48) var text_size: int = 16:
	set(value):
		text_size = value
		_update_text_label()

@export_category("Box Settings")
@export var bg_color: Color = Color(1, 1, 1, 1):
	set(value):
		bg_color = value
		_update_box()
@export var text_color: Color = Color(0, 0, 0, 1):
	set(value):
		text_color = value
		_update_text_label()
@export var padding_x: int = 16:
	set(value):
		padding_x = value
		_update_margin_box()
@export var padding_y: int = 5:
	set(value):
		padding_y = value
		_update_margin_box()
@export var spacing_x: int = 0:
	set(value):
		spacing_x = value
		_update_hbox_container()

@export_category("Developer Settings")
@export var texture_atlas: Dictionary[DeviceType, AtlasTexture] = {}
@export var debug_key: bool = false

var pressed_key: String = ""

var atlas_naming: Dictionary[DeviceType, KeyManager] = {}

func calculate_mono_spacing(_size: int) -> int:
	# Calculate spacing: 16->-12, 24->-16
	return int(-0.5 * _size - 4)

func _ready() -> void:
	atlas_naming.set(DeviceType.KEYBOARD, KeyManager.new("res://assets/input_prompts/keyboard_mouse/texture.xml"))
	atlas_naming.set(DeviceType.XBOX, KeyManager.new("res://assets/input_prompts/xbox_series/texture.xml"))
	atlas_naming.set(DeviceType.STEAM_DECK, KeyManager.new("res://assets/input_prompts/steam_deck/texture.xml"))

	# Listening to device change
	Game.ON_INPUT_DEVICE_CHANGE.connect(_on_input_device_change)

	_update_text_label()
	_update_box()

	# If true it handles unhandled input
	set_process_unhandled_input(debug_key)

func _unhandled_input(_event: InputEvent) -> void:
	if _event is InputEventKey:
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(_event.physical_keycode)
		var os_key_name = OS.get_keycode_string(keycode).to_lower()
		pressed_key = os_key_name
		_update_current_icon()
	elif _event is InputEventJoypadButton:
		print("KeySuggestion, JOYPAD pressed key: %s" % _event.button_index)
		pressed_key = str(_event.button_index)
		_update_current_icon()
	
func apply_mono_font_spacing(spacing: int) -> void:
	# Get the theme font or create a new one
	var joyName = Input.get_joy_name(Game._input_device_id).to_lower()
	var mono_font = rich_text_label.get_theme_font("mono_font")

	# Setting the font	
	if "xbox" in joyName:
		pass
	elif "steam" in joyName:
		pass
	else:
		pass

	print("[%s] Mono font: %s" % [self.name, mono_font.get_font_name()])

	if mono_font:
		# Create a FontVariation if it's not already one
		var font_variation: FontVariation
		if mono_font is FontVariation:
			font_variation = mono_font
		else:
			font_variation = FontVariation.new()
			font_variation.base_font = mono_font
		
		# Apply spacing_top
		font_variation.set_spacing(TextServer.SPACING_TOP, spacing)

		print("Spacing applied: %s" % spacing)
		
		# Assign the modified font to the theme
		rich_text_label.add_theme_font_override("mono_font", font_variation)

func _on_input_device_change(_device_id: int) -> void:
	print("[%s] device_changed: %s" % [self.name, _device_id])
	_update_text_label()

func _update_text_label() -> void:
	if not rich_text_label: return
	rich_text_label.visible = false
	var icon_size = text_size * icon_scale_ratio
	
	# Update icon_rect size to match the calculated icon_size
	icon_rect.custom_minimum_size = Vector2(icon_size, icon_size)
	icon_rect.modulate = text_color
	_update_icon_atlas()

	# Calculate spacing automatically
	var mono_spacing = calculate_mono_spacing(text_size)
	
	# Apply spacing to the mono font
	apply_mono_font_spacing(mono_spacing)

	var replaced_text = exampleText.format({
		"text_size": text_size,
		"text": self.text,
		"text_color": text_color.to_html(true)
	})
	
	rich_text_label.bbcode_enabled = true
	rich_text_label.set_text(replaced_text)
	rich_text_label.visible = true

	_update_current_icon()
	_update_box()
	_update_margin_box()
	_update_hbox_container()

func _update_box() -> void:
	var _theme = self.get_theme_stylebox("panel")
	if not _theme: return

	_theme.bg_color = bg_color
	self.add_theme_stylebox_override("panel", _theme)
	
func _update_margin_box() -> void:
	if not margin_box: return
	margin_box.add_theme_constant_override("margin_left", padding_x)
	margin_box.add_theme_constant_override("margin_right", padding_x)
	margin_box.add_theme_constant_override("margin_top", padding_y)
	margin_box.add_theme_constant_override("margin_bottom", padding_y)

func _update_hbox_container() -> void:
	if not hbox_container: return
	hbox_container.add_theme_constant_override("separation", spacing_x)

func _update_current_icon() -> void:
	for event in InputMap.action_get_events(self.ui_key):
		if event is InputEventKey and Game._input_device_id == -1:
			var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
			var os_key_name = OS.get_keycode_string(keycode).to_lower()
			var keyMapping = _get_atlas_mapping("keyboard", "outline", pressed_key if debug_key else os_key_name)
			
			if not keyMapping:
				return

			_update_atlas(keyMapping)
		elif event is InputEventJoypadButton and Game._input_device_id != -1:
			var joyconName = Input.get_joy_name(Game._input_device_id).to_lower()
			print("[%s] Joypad: %s" % [joyconName, event.button_index])

			if "xbox" in joyconName:
				var keyMapping = _get_atlas_mapping("xbox", "outline", pressed_key if debug_key else str(event.button_index))
				if not keyMapping:
					return

				_update_atlas(keyMapping)
			else:
				pass

func _update_atlas(mapping: KeyMapping) -> void:
	var atlasTexture: AtlasTexture = icon_rect.texture
	atlasTexture.region = mapping.get_rect_position()
	icon_rect.texture = atlasTexture

func _update_icon_atlas() -> void:
	icon_rect.texture = texture_atlas[_get_device_name()]

func _get_device_name() -> DeviceType:
	if Game._input_device_id == -1:
		return DeviceType.KEYBOARD

	var joyName = Input.get_joy_name(Game._input_device_id).to_lower()
	if "xbox" in joyName:
		return DeviceType.XBOX
	else:
		return DeviceType.STEAM_DECK

func _get_atlas_mapping(prefix: String, suffix: String, key: String) -> KeyMapping:
	var placeholder = "%s_%s_%s" % [prefix, key, suffix]

	var deviceName = _get_device_name()
	var keyMap = atlas_naming[deviceName].get_key_mapping(placeholder)

	if not keyMap:
		print("KeyMapping not found: %s" % placeholder)
		return null
	
	return keyMap
