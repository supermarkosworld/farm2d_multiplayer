class_name NPC
extends CharacterBody2D

@export var min_walk_cycle: int  = 2
@export var max_walk_cycle: int = 6

var walk_cycles: int
var current_walk_cycle: int

@onready var state_machine: NPCNodeStateMachine = $NPCNodeStateMachine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	# Initialize walk cycles
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	
	# Set up states
	var idle_state = $NPCNodeStateMachine/Idle
	var walk_state = $NPCNodeStateMachine/Walk
	
	if idle_state:
		idle_state.character = self
		idle_state.animated_sprite_2d = animated_sprite_2d
		print("Idle state setup for: ", name)
	
	if walk_state:
		walk_state.character = self
		walk_state.animated_sprite_2d = animated_sprite_2d
		walk_state.navigation_agent_2d = navigation_agent_2d
		print("Walk state setup for: ", name)
	
	print("NPC ready: ", name)
