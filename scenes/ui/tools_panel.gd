extends Node

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
@onready var tool_corn: Button = $MarginContainer/HBoxContainer/ToolCorn
@onready var tool_tomato: Button = $MarginContainer/HBoxContainer/ToolTomato

func _ready() -> void:
	# Check button validity first
	if not is_instance_valid(tool_axe) or not is_instance_valid(tool_tilling) or \
	   not is_instance_valid(tool_watering_can) or not is_instance_valid(tool_corn) or \
	   not is_instance_valid(tool_tomato):
		printerr("ToolsPanel Error: One or more tool buttons are not valid instances! Check paths in editor.")
		return
	   
	# Connect button signals
	tool_axe.pressed.connect(_on_tool_button_pressed.bind(DataTypes.Tools.AxeWood))
	tool_tilling.pressed.connect(_on_tool_button_pressed.bind(DataTypes.Tools.TillGround))
	tool_watering_can.pressed.connect(_on_tool_button_pressed.bind(DataTypes.Tools.WaterCrops))
	tool_corn.pressed.connect(_on_tool_button_pressed.bind(DataTypes.Tools.PlantCorn))
	tool_tomato.pressed.connect(_on_tool_button_pressed.bind(DataTypes.Tools.PlantTomato))
	print("ToolsPanel: _ready finished connecting signals.")

func _on_tool_button_pressed(tool_type: DataTypes.Tools) -> void:
	print("ToolsPanel: Button pressed for tool: ", tool_type, ". Emitting GameManager.local_tool_selected")
	# Emit the signal via the GameManager autoload
	GameManager.emit_signal("local_tool_selected", tool_type)

func _gui_input(event: InputEvent) -> void:
	# Check specifically for left mouse button presses within the panel area
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print("ToolsPanel: _gui_input consuming left click.")
		# Mark the event as handled via the viewport
		get_viewport().set_input_as_handled()
