extends Node2D

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var eagle: Area2D = $Eagle
@onready var round_start_timer: Timer = $RoundStartTimer

const WALKABLE_TILE: Vector2i = Vector2i(0, 0)
const TOWER_SCENE = preload("uid://ckod6a185q6fh")
const enemies: Array = [preload("uid://drgu2o61e8iki"), preload("uid://cjxa2ahc3d6py")]

var screen_width: float
var waves: int = 5
var current_wave: int = 1

var number_of_tanks: int


func _ready() -> void:
	GameManager.enemy_died.connect(_on_enemy_died)
	round_start_timer.timeout.connect(_on_round_start_timer_timeout)

	var viewport = get_viewport_rect()
	screen_width = viewport.size.x

	_update_number_of_tanks()
	_spawn_enemy(number_of_tanks)
	_place_towers(2)

	GameManager.tile_destroyed.connect(_on_tile_destroyed)
	GameManager.game_ended.connect(_on_game_ended)


func _update_number_of_tanks() -> void:
	number_of_tanks = current_wave + 2


func _on_tile_destroyed(pos: Vector2i) -> void:
	ground_layer.set_cell(pos, 1, WALKABLE_TILE)


func _spawn_enemy(count: int) -> void:
	for c in count:
		var spawn_position: float = randf_range(10.0, screen_width - 10)
		var enemy = enemies.pick_random().instantiate()
		enemy.target = eagle.position
		enemy.speed = enemy.speed + current_wave
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


func _on_enemy_died() -> void:
	number_of_tanks -= 1
	if number_of_tanks <= 0:
		current_wave += 1
		_update_number_of_tanks()
		print(number_of_tanks)
		round_start_timer.start()


func _on_round_start_timer_timeout() -> void:
	print("round timer timeout")
	_spawn_enemy(number_of_tanks)
