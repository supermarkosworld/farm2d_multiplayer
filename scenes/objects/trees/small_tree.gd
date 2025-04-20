extends Sprite2D

@onready var damage_component: DamageComponent = $DamageComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var log_scene = preload("res://scenes/objects/trees/log.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)
	# Create a unique material instance for this tree
	material = material.duplicate()
	material.set_shader_parameter("shake_intensity", 0.0)

func on_hurt(damage: int) -> void:
	damage_component.apply_damage(damage)
	material.set_shader_parameter("shake_intensity", 0.5)
	await get_tree().create_timer(0.2).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damaged_reached() -> void:
	add_log_scene()
	queue_free()

func add_log_scene() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
