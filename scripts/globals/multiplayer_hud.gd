extends Node

@onready var host_button = $Panel/VBoxContainer/HostGame
@onready var join_button = $Panel/VBoxContainer/JoinAsPlayer
@onready var panel = $Panel





func _ready():
	# Connect the buttons to their respective functions
	host_button.pressed.connect(_on_host_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)

func _on_host_button_pressed():
	GameManager.become_host()
	# Hide the panel after hosting
	panel.hide()

func _on_join_button_pressed():
	GameManager.join_as_player()
	# Hide the panel after joining
	panel.hide()
