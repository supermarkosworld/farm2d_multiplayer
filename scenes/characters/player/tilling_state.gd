extends NodeState

@onready var player = get_parent().get_parent() as Player
@onready var input = player.get_node("%InputSynchronizer")
@export var animated_sprite_2d: AnimatedSprite2D

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")

func _on_enter() -> void:
	animated_sprite_2d.play(player.get_animation_name("tilling"))

func _on_exit() -> void:
	animated_sprite_2d.stop()
