extends Node2D

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var eagle: Area2D = $Eagle

const WALKABLE_TILE: Vector2i = Vector2i(0, 0)

const TOWER_SCENE = preload("uid://ckod6a185q6fh")
const enemies: Array = [preload("uid://drgu2o61e8iki"), preload("uid://cjxa2ahc3d6py")]

var screen_width: float


func _ready() -> void:
	var viewport = get_viewport_rect()
	screen_width = viewport.size.x
	enemy_spawn_timer.timeout.connect(_spawn_enemy)
	_spawn_enemy()
	_place_towers(3)

	GameManager.tile_destroyed.connect(_on_tile_destroyed)
	GameManager.game_ended.connect(_on_game_ended)


func _on_tile_destroyed(pos: Vector2i) -> void:
	ground_layer.set_cell(pos, 1, WALKABLE_TILE)


func _spawn_enemy() -> void:
	var spawn_position: float = randf_range(10.0, screen_width - 10)
	var enemy = enemies.pick_random().instantiate()
	enemy.target = eagle.position
	enemy.tilemap_layer = ground_layer
	add_child(enemy)
	enemy.position = Vector2(spawn_position, -50.0)


func _place_towers(count: int, min_distance: float = 150.0) -> void:
	var cells = ground_layer.get_used_cells()
	cells.shuffle()
	var placed_positions: Array[Vector2] = []
	for cell in cells:
		if placed_positions.size() >= count:
			break

		var pos = ground_layer.map_to_local(cell)
		var too_close = false
		for placed in placed_positions:
			if pos.distance_to(placed) < min_distance:
				too_close = true
				break
		if too_close:
			continue

		var tower = TOWER_SCENE.instantiate()
		add_child(tower)
		tower.position = pos
		placed_positions.append(pos)


func _on_game_ended() -> void:
	GameManager.go_to_gameover_menu()
