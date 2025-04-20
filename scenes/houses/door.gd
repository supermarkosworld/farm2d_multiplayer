extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interactable_component: InteractableComponent = $InteractableComponent

func _ready() -> void:
	# Connect signals properly
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)

# Define the activated signal handler
func on_interactable_activated() -> void:
	animated_sprite_2d.play("open_door")  # Play the "open_door" animation
	collision_layer = 2
	print("activated")

# Define the deactivated signal handler
func on_interactable_deactivated() -> void:
	animated_sprite_2d.play("close_door")  # Play the "close_door" animation
	collision_layer = 1	
	print("deactivated")
