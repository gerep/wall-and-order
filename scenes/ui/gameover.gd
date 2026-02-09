extends CanvasLayer

@onready var try_again_button: Button = %TryAgainButton
@onready var back_to_menu: Button = %BackToMenu


func _ready() -> void:
	pass
	try_again_button.pressed.connect(_on_try_again_pressed)
	back_to_menu.pressed.connect(_on_back_to_menu_pressed)
	back_to_menu.mouse_entered.connect(_on_back_to_menu_mouse_entered)
	back_to_menu.mouse_exited.connect(_on_back_to_menu_mouse_exited)
	try_again_button.mouse_entered.connect(_on_try_again_button_mouse_entered)
	try_again_button.mouse_exited.connect(_on_try_again_button_mouse_exited)


func _on_try_again_pressed() -> void:
	GameManager.go_to_level()


func _on_back_to_menu_pressed() -> void:
	GameManager.go_to_main_menu()


func _on_play_button_pressed() -> void:
	GameManager.go_to_level()


func _on_back_to_menu_mouse_entered() -> void:
	back_to_menu.rotation = deg_to_rad([-2.0, 2.0].pick_random())


func _on_back_to_menu_mouse_exited() -> void:
	back_to_menu.rotation = 0.0


func _on_try_again_button_mouse_entered() -> void:
	try_again_button.rotation = deg_to_rad([-2.0, 2.0].pick_random())


func _on_try_again_button_mouse_exited() -> void:
	try_again_button.rotation = 0.0
