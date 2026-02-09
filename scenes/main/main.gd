extends Node2D

@onready var play_button: Button = %PlayButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	play_button.mouse_entered.connect(_on_mouse_entered)
	play_button.mouse_exited.connect(_on_mouse_exited)


func _on_play_button_pressed() -> void:
	GameManager.go_to_level()


func _on_mouse_entered() -> void:
	play_button.rotation = deg_to_rad([-2.0, 2.0].pick_random())


func _on_mouse_exited() -> void:
	play_button.rotation = 0.0
