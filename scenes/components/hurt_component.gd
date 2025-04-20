class_name HurtComponent

extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.None

signal hurt

func _ready() -> void:
	# Set collision layers for objects
	collision_layer = 5  # Layer 5 (objects)
	collision_mask = 4   # Layer 4 (tools)
	
	# Ensure monitoring is enabled
	monitoring = true
	monitorable = true
	
	# Connect area_entered signal
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

func _physics_process(_delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	var hit_component = area as HitComponent
	if hit_component:
		if tool == hit_component.current_tool:
			hurt.emit(hit_component.hit_damage)
