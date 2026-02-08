extends Node2D

signal tile_destroyed(pos: Vector2i)
signal game_ended
signal enemy_died


func go_to_gameover_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/gameover.tscn")


func go_to_level() -> void:
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")


func go_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
