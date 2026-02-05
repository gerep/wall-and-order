extends CanvasLayer

@onready var try_again_button: Button = %TryAgainButton
@onready var back_to_menu: Button = %BackToMenu


func _ready() -> void:
	pass
	try_again_button.pressed.connect(_on_try_again_pressed)
	back_to_menu.pressed.connect(_on_back_to_menu_pressed)


func _on_try_again_pressed() -> void:
	GameManager.go_to_level()


func _on_back_to_menu_pressed() -> void:
	GameManager.go_to_main_menu()
