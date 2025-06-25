class_name KeySuggestion
extends PanelContainer

var XBOX_BUTTON_TO_ICON: Dictionary = {
	# Principal buttons
	0: "\uE005", # JOY_BUTTON_A -> xbox_button_a_outline
	1: "\uE007", # JOY_BUTTON_B -> xbox_button_b_outline
	2: "\uE01F", # JOY_BUTTON_X -> xbox_button_x_outline
	3: "\uE021", # JOY_BUTTON_Y -> xbox_button_y_outline
	
	# Shoulder buttons
	9: "\uE044", # JOY_BUTTON_LEFT_SHOULDER -> xbox_lb_outline
	10: "\uE04A", # JOY_BUTTON_RIGHT_SHOULDER -> xbox_rb_outline
	
	# Special buttons
	4: "\uE01D", # JOY_BUTTON_BACK -> xbox_button_view_outline
	6: "\uE015", # Menu button -> xbox_button_menu_outline

	# Sticks click
	7: "\uE046", # JOY_BUTTON_LEFT_STICK -> xbox_ls_outline
	8: "\uE04C", # JOY_BUTTON_RIGHT_STICK -> xbox_rs_outline
	
	# D-Pad
	11: "\uE036", # JOY_BUTTON_DPAD_UP -> xbox_dpad_up_outline
	12: "\uE025", # JOY_BUTTON_DPAD_DOWN -> xbox_dpad_down_outline
	13: "\uE029", # JOY_BUTTON_DPAD_LEFT -> xbox_dpad_left_outline
	14: "\uE02C", # JOY_BUTTON_DPAD_RIGHT -> xbox_dpad_right_outline
	
	# Guide button
	5: "\uE042", # JOY_BUTTON_GUIDE -> xbox_guide_outline
}

var KEYBOARD_BUTTON_TO_ICON: Dictionary = {
	# Numbers 0-9
	48: "\uE002", # KEY_0 -> keyboard_0_outline
	49: "\uE004", # KEY_1 -> keyboard_1_outline
	50: "\uE006", # KEY_2 -> keyboard_2_outline
	51: "\uE008", # KEY_3 -> keyboard_3_outline
	52: "\uE00A", # KEY_4 -> keyboard_4_outline
	53: "\uE00C", # KEY_5 -> keyboard_5_outline
	54: "\uE00E", # KEY_6 -> keyboard_6_outline
	55: "\uE010", # KEY_7 -> keyboard_7_outline
	56: "\uE012", # KEY_8 -> keyboard_8_outline
	57: "\uE014", # KEY_9 -> keyboard_9_outline
	
	# Letters A-Z
	65: "\uE016", # KEY_A -> keyboard_a_outline
	66: "\uE037", # KEY_B -> keyboard_b_outline
	67: "\uE047", # KEY_C -> keyboard_c_outline
	68: "\uE057", # KEY_D -> keyboard_d_outline
	69: "\uE05B", # KEY_E -> keyboard_e_outline
	70: "\uE07F", # KEY_F -> keyboard_f_outline
	71: "\uE083", # KEY_G -> keyboard_g_outline
	72: "\uE085", # KEY_H -> keyboard_h_outline
	73: "\uE089", # KEY_I -> keyboard_i_outline
	74: "\uE08D", # KEY_J -> keyboard_j_outline
	75: "\uE08F", # KEY_K -> keyboard_k_outline
	76: "\uE091", # KEY_L -> keyboard_l_outline
	77: "\uE093", # KEY_M -> keyboard_m_outline
	78: "\uE097", # KEY_N -> keyboard_n_outline
	79: "\uE09F", # KEY_O -> keyboard_o_outline
	80: "\uE0A4", # KEY_P -> keyboard_p_outline
	81: "\uE0B0", # KEY_Q -> keyboard_q_outline
	82: "\uE0B6", # KEY_R -> keyboard_r_outline
	83: "\uE0BA", # KEY_S -> keyboard_s_outline
	84: "\uE0CA", # KEY_T -> keyboard_t_outline
	85: "\uE0D4", # KEY_U -> keyboard_u_outline
	86: "\uE0D6", # KEY_V -> keyboard_v_outline
	87: "\uE0D8", # KEY_W -> keyboard_w_outline
	88: "\uE0DC", # KEY_X -> keyboard_x_outline
	89: "\uE0DE", # KEY_Y -> keyboard_y_outline
	90: "\uE0E0", # KEY_Z -> keyboard_z_outline
	
	# Function keys F1-F12
	16777244: "\uE06E", # KEY_F1 -> keyboard_f1_outline
	16777245: "\uE070", # KEY_F2 -> keyboard_f2_outline
	16777246: "\uE072", # KEY_F3 -> keyboard_f3_outline
	16777247: "\uE074", # KEY_F4 -> keyboard_f4_outline
	16777248: "\uE076", # KEY_F5 -> keyboard_f5_outline
	16777249: "\uE078", # KEY_F6 -> keyboard_f6_outline
	16777250: "\uE07A", # KEY_F7 -> keyboard_f7_outline
	16777251: "\uE07C", # KEY_F8 -> keyboard_f8_outline
	16777252: "\uE07E", # KEY_F9 -> keyboard_f9_outline
	16777253: "\uE069", # KEY_F10 -> keyboard_f10_outline
	16777254: "\uE06B", # KEY_F11 -> keyboard_f11_outline
	16777255: "\uE06D", # KEY_F12 -> keyboard_f12_outline
	
	# Special keys
	32: "\uE0C7", # KEY_SPACE -> keyboard_space_outline
	4194309: "\uE05F", # KEY_ENTER -> keyboard_enter_outline
	4194325: "\uE0C0", # KEY_SHIFT -> keyboard_shift_outline
	4194326: "\uE055", # KEY_CTRL -> keyboard_ctrl_outline
	4194328: "\uE018", # KEY_ALT -> keyboard_alt_outline
	4194305: "\uE063", # KEY_ESCAPE -> keyboard_escape_outline
	4194312: "\uE059", # KEY_DELETE -> keyboard_delete_outline
	4194308: "\uE03D", # KEY_BACKSPACE -> keyboard_backspace_outline
	4194306: "\uE0CE", # KEY_TAB -> keyboard_tab_outline
	4194317: "\uE087", # KEY_HOME -> keyboard_home_outline
	4194318: "\uE05D", # KEY_END -> keyboard_end_outline
	4194323: "\uE0A8", # KEY_PAGEUP -> keyboard_page_up_outline
	4194324: "\uE0A6", # KEY_PAGEDOWN -> keyboard_page_down_outline
	4194311: "\uE08B", # KEY_INSERT -> keyboard_insert_outlet
	4194329: "\uE04B", # KEY_CAPSLOCK -> keyboard_capslock_outline
	4194330: "\uE099", # KEY_NUMLOCK -> keyboard_numlock_outline
	4194314: "\uE0AE", # KEY_PRINT -> keyboard_printscreen_outline
	
	# Arrow keys
	4194320: "\uE024", # KEY_UP -> keyboard_arrow_up_outline
	4194322: "\uE01E", # KEY_DOWN -> keyboard_arrow_down_outline
	4194319: "\uE020", # KEY_LEFT -> keyboard_arrow_left_outline
	4194321: "\uE022", # KEY_RIGHT -> keyboard_arrow_right_outline
	
	# Symbols and punctuation
	45: "\uE095", # KEY_MINUS -> keyboard_minus_outline
	4194435: "\uE095", # NUM_KEY_MINUS -> keyboard_minus_outline
	61: "\uE061", # KEY_EQUAL -> keyboard_equals_outline
	4194310: "\uE061", # NUM_KEY_EQUAL -> keyboard_equals_outline
	91: "\uE045", # KEY_BRACKETLEFT -> keyboard_bracket_open_outline
	93: "\uE03F", # KEY_BRACKETRIGHT -> keyboard_bracket_close_outline
	92: "\uE0C2", # KEY_BACKSLASH -> keyboard_slash_back_outline
	47: "\uE0C4", # KEY_SLASH -> keyboard_slash_forward_outline
	59: "\uE0BC", # KEY_SEMICOLON -> keyboard_semicolon_outline
	39: "\uE01C", # KEY_APOSTROPHE -> keyboard_apostrophe_outline
	96: "\uE0D2", # KEY_QUOTELEFT -> keyboard_tilde_outline
	44: "\uE051", # KEY_COMMA -> keyboard_comma_outline
	46: "\uE0AA", # KEY_PERIOD -> keyboard_period_outline
	
	# Numeric keyboard
	16777351: "\uE09B", # KEY_KP_ENTER -> keyboard_numpad_enter_outline
	16777350: "\uE09D", # KEY_KP_ADD -> keyboard_numpad_plus_outline
}

@onready var exampleText = """[table=1,c,c]
[cell][code][font_size={icon_size}]{icon}[/font_size][/code][/cell]
[/table] [font_size={text_size}]{text}[/font_size]"""

@onready var rich_text_label: RichTextLabel = $RichTextLabel

@export var text: String = ""
@export var ui_key: String = ""

@export_category("Text Settings")
@export var icon_scale_ratio: float = 2.25
@export var text_size: int = 16

@export_category("Developer Settings")
@export var fonts: Dictionary[String, Font]
@export var debug_key: bool = false

var device_id: int = -1
var pressed_key: int = -1

func calculate_mono_spacing(_size: int) -> int:
	# Calculate spacing: 16->-12, 24->-16
	return int(-0.5 * _size - 4)

func _ready() -> void:
	Input.connect("joy_connection_changed", self._joy_connection_changed)
	_update_text_label()

	# If true it handles unhandled input
	set_process_unhandled_input(debug_key)
	
func _unhandled_input(_event: InputEvent) -> void:
	if _event is InputEventKey:
		print("KeySuggestion, KEYBOARD pressed key: %s" % _event.keycode)
		pressed_key = _event.keycode
		_update_text_label()
	elif _event is InputEventJoypadButton:
		print("KeySuggestion, JOYPAD pressed key: %s" % _event.button_index)
		pressed_key = _event.button_index
		_update_text_label()
	
func apply_mono_font_spacing(spacing: int) -> void:
	# Get the theme font or create a new one
	var joyName = Input.get_joy_name(device_id).to_lower()
	var mono_font = rich_text_label.get_theme_font("mono_font")

	# Setting the font	
	if "xbox" in joyName:
		mono_font.base_font = fonts["xbox"]
	elif "steam" in joyName:
		mono_font.base_font = fonts["steam"]
	else:
		mono_font.base_font = fonts["keyboard"]

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

func _joy_connection_changed(_device_id: int, _connected: bool) -> void:
	if not _connected:
		self.device_id = -1
	else:
		self.device_id = _device_id
	
	# Updating Rich Label
	_update_text_label()

func _update_text_label() -> void:
	rich_text_label.visible = false
	var icon_size = text_size * icon_scale_ratio
	
	# Calculate spacing automatically
	var mono_spacing = calculate_mono_spacing(text_size)
	
	# Apply spacing to the mono font
	apply_mono_font_spacing(mono_spacing)

	var icon: String

	if pressed_key != -1:
		icon = _get_debug_key()
	else:
		icon = _get_current_icon()
	
	var replaced_text = exampleText.format({
		"icon_size": icon_size,
		"text_size": text_size,
		"icon": icon,
		"text": self.text
	})
	
	rich_text_label.bbcode_enabled = true
	rich_text_label.set_text(replaced_text)
	rich_text_label.visible = true

func _get_current_icon() -> String:
	for event in InputMap.action_get_events(self.ui_key):
		if event is InputEventKey and device_id == -1:
			print("Key: %s" % event.keycode)
			return KEYBOARD_BUTTON_TO_ICON.get(event.keycode, "b")
		elif event is InputEventJoypadButton and device_id != -1:
			var joyconName = Input.get_joy_name(device_id).to_lower()
			print("[%s] Joypad: %s" % [joyconName, event.button_index])

			if "xbox" in joyconName:
				return XBOX_BUTTON_TO_ICON.get(event.button_index, "b")
			else:
				return "b"
	return ""

func _get_debug_key() -> String:
	if device_id == -1:
		return KEYBOARD_BUTTON_TO_ICON.get(pressed_key, "b")
	elif device_id != -1:
		var joyconName = Input.get_joy_name(device_id).to_lower()
		if "xbox" in joyconName:
			return XBOX_BUTTON_TO_ICON.get(pressed_key, "b")
		else:
			return "🛑"
	return "❌"
