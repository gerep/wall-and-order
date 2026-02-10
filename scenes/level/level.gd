extends Node2D

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var eagle: Area2D = $Eagle
@onready var round_start_timer: Timer = $RoundStartTimer

const WALKABLE_TILE: Vector2i = Vector2i(0, 0)
const TOWER_SCENE = preload("uid://ckod6a185q6fh")
const GAME_OVER_SOUND: AudioStream = preload("uid://ck0r18gxjpbcy")
const NEW_WAVE_SOUND: AudioStream = preload("uid://1hq430l5skq3")
const enemies: Array = [preload("uid://drgu2o61e8iki"), preload("uid://cjxa2ahc3d6py")]

var screen_width: float
var waves: int = 5
var current_wave: int = 1

var number_of_tanks: int

var game_ended_received: bool


func _ready() -> void:
	GameManager.enemy_died.connect(_on_enemy_died)
	round_start_timer.timeout.connect(_on_round_start_timer_timeout)

	var viewport = get_viewport_rect()
	screen_width = viewport.size.x

	_randomize_eagle_position()
	_update_number_of_tanks()
	_spawn_enemy(number_of_tanks)
	_place_towers(2)

	GameManager.tile_destroyed.connect(_on_tile_destroyed)
	GameManager.game_ended.connect(_on_game_ended)


func _randomize_eagle_position() -> void:
	var cells = ground_layer.get_used_cells()
	var bottom_cells: Array[Vector2i] = []
	var max_y: int = cells[0].y
	for cell in cells:
		if cell.y > max_y:
			max_y = cell.y
	for cell in cells:
		if cell.y == max_y:
			bottom_cells.append(cell)
	var chosen_cell = bottom_cells.pick_random()
	eagle.position = ground_layer.map_to_local(chosen_cell)


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


func _place_towers(count: int, min_distance: float = 150.0, eagle_distance: float = 200.0) -> void:
	var cells = ground_layer.get_used_cells()
	cells.shuffle()
	var placed_positions: Array[Vector2] = []
	for cell in cells:
		if placed_positions.size() >= count:
			break

		var pos = ground_layer.map_to_local(cell)

		if pos.y >= eagle.position.y or pos.distance_to(eagle.position) < eagle_distance:
			continue

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
	if game_ended_received:
		return

	game_ended_received = true
	AudioManager.play(GAME_OVER_SOUND)
	await get_tree().create_timer(2.30).timeout

	GameManager.go_to_gameover_menu()


func _on_enemy_died() -> void:
	number_of_tanks -= 1
	if number_of_tanks <= 0:
		current_wave += 1
		_update_number_of_tanks()
		print(number_of_tanks)
		round_start_timer.start()


func _on_round_start_timer_timeout() -> void:
	AudioManager.play(NEW_WAVE_SOUND)
	await get_tree().create_timer(2.0).timeout
	_spawn_enemy(number_of_tanks)
