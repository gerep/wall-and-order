extends CharacterBody2D
class_name Player

const SPRITE_SIZE: int = 64

const BRICK_WALL: Vector2i = Vector2i(3, 0)
const STONE_WALL: Vector2i = Vector2i(3, 1)
const BRICK_WALL_ASSET: Texture2D = preload("uid://6x208hcnf2s5")
const STONE_WALL_ASSET: Texture2D = preload("uid://birqxa5n8j47o")

const PLACING_BLOCK_SOUND: AudioStream = preload("uid://d3joi56g2weqc")
const INVALID_PLACING_BLOCK_SOUND: AudioStream = preload("uid://djjcufbmsnm8a")

const NUM_PLACEMENTS_BEFORE_STONE: int = 4

@export var speed: float = 400.0
@export var acceleration: float = 1000.0
@export var friction: float = 2000.0
@export var rotation_speed: float = 10.0
@export var tilemap_layer: TileMapLayer

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var next_wall: Sprite2D = $NextWall
@onready var placement_timer: Timer = $PlacementTimer

var input_direction: Vector2
var last_direction: Vector2
var placement_count: int = -1
var wall_sequence: Array = [BRICK_WALL, BRICK_WALL, STONE_WALL]
var can_place: bool = true

var wall_textures: Dictionary = {
	BRICK_WALL: BRICK_WALL_ASSET,
	STONE_WALL: STONE_WALL_ASSET,
}

var ground_tiles: Array[Vector2i] = [
	Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 2), Vector2i(0, 3), Vector2i(1, 3)
]


func _ready() -> void:
	next_wall.texture = BRICK_WALL_ASSET
	placement_timer.timeout.connect(_on_placement_timer_timeout)


func _physics_process(delta: float) -> void:
	input_direction = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")

	_handle_movement(delta)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"place") and can_place:
		can_place = false
		placement_timer.start()

		placement_count = wrapi(placement_count + 1, 0, wall_sequence.size())
		var current_wall: Vector2i = wall_sequence[placement_count]
		var next_index = wrapi(placement_count + 1, 0, wall_sequence.size())
		next_wall.texture = wall_textures[wall_sequence[next_index]]

		# Grab the cell behind the player based on the last direction the player is facing.
		var cell_position = position - (last_direction * SPRITE_SIZE)
		var map_coord = tilemap_layer.local_to_map(cell_position)

		# If the tilemap cell is already with a wall, ignore the placement.
		if tilemap_layer.get_cell_atlas_coords(map_coord) not in ground_tiles:
			placement_count -= 1
			AudioManager.play(INVALID_PLACING_BLOCK_SOUND)
			return

		tilemap_layer.set_cell(map_coord, 1, current_wall)
		AudioManager.play(PLACING_BLOCK_SOUND)


func _handle_movement(delta: float) -> void:
	var target_speed = speed

	if input_direction != Vector2.ZERO:
		last_direction = input_direction
		velocity = velocity.move_toward(input_direction * target_speed, acceleration * delta)
		var target_rotation = input_direction.angle()
		sprite_2d.rotation = lerp_angle(sprite_2d.rotation, target_rotation, rotation_speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)


func _on_placement_timer_timeout() -> void:
	can_place = true
