extends CharacterBody2D
class_name Player

const SPRITE_SIZE:int = 64
const BRICK_WALL: Vector2i = Vector2i(1, 0)
const STONE_WALL: Vector2i = Vector2i(2, 0)

@export var speed: float = 400.0
@export var acceleration: float = 1000.0
@export var friction: float = 2000.0
@export var rotation_speed: float = 10.0
@export var tilemap_layer: TileMapLayer

@onready var sprite_2d: Sprite2D = $Sprite2D

var input_direction: Vector2
var last_direction: Vector2


func _physics_process(delta: float) -> void:
	input_direction = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")

	_handle_movement(delta)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"place"):
		var cell_position = position - (last_direction*SPRITE_SIZE)
		tilemap_layer.set_cell(tilemap_layer.local_to_map(cell_position), 1, BRICK_WALL)


func _handle_movement(delta: float) -> void:
	var target_speed = speed

	if input_direction != Vector2.ZERO:
		last_direction = input_direction
		velocity = velocity.move_toward(input_direction * target_speed, acceleration * delta)
		var target_rotation = input_direction.angle() + PI / 2
		sprite_2d.rotation = lerp_angle(sprite_2d.rotation, target_rotation, rotation_speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
