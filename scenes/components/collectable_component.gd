class_name CollectableComponent
extends Area2D


@export var collectable_name: String

func _ready() -> void:

	body_entered.connect(_on_body_entered)	

func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name)
	if body is Player:
		print("Player entered: ", collectable_name)
		get_parent().queue_free()
