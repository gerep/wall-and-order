extends Node2D

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var eagle: Area2D = $Eagle

const BASIC_ENEMY = preload("uid://bke42ss266g4p")
const WALKABLE_TILE: Vector2i = Vector2i(0, 0)

var screen_width: float


func _ready() -> void:
	var viewport = get_viewport_rect()
	screen_width = viewport.size.x
	#enemy_spawn_timer.timeout.connect(_spawn_enemy)
	_spawn_enemy()

	GameManager.tile_destroyed.connect(_on_tile_destroyed)
	GameManager.game_ended.connect(_on_game_ended)


func _on_tile_destroyed(pos: Vector2i) -> void:
	ground_layer.set_cell(pos, 1, WALKABLE_TILE)


func _spawn_enemy() -> void:
	var spawn_position: float = randf_range(10.0, screen_width - 10)
	var enemy = BASIC_ENEMY.instantiate()
	enemy.target = eagle.position
	enemy.tilemap_layer = ground_layer
	add_child(enemy)
	enemy.position = Vector2(spawn_position, -50.0)


func _on_game_ended() -> void:
	GameManager.go_to_gameover_menu()
