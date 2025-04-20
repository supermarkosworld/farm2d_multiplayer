class_name NPCNodeState
extends Node

@warning_ignore("unused_signal")
signal transition 

# Reference to the NPC this state belongs to
@export var character: NPC
@export var animated_sprite_2d: AnimatedSprite2D

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	pass
