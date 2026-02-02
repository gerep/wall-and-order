extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shooting_timer: Timer = $ShootingTimer

@export var target: Vector2
@export var speed: float = 50.0
@export var acceleration: float = 500.0
@export var friction: float = 2000.0
@export var tilemap_layer: TileMapLayer

const BRICK_WALL: Vector2i = Vector2i(1, 0)
const STONE_WALL: Vector2i = Vector2i(2, 0)
const BULLET = preload("uid://pxhsie8ss6aa")

var can_shoot: bool = true
var can_move: bool = true


func _ready() -> void:
	navigation_agent_2d.target_position = target
	shooting_timer.timeout.connect(_on_shotting_timer_timeout)


func _physics_process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished() || not can_move:
		return

	if ray_cast_2d.is_colliding():
		if ray_cast_2d.get_collider() is TileMapLayer:
			var map_coord = tilemap_layer.local_to_map(ray_cast_2d.get_collision_point())
			if tilemap_layer.get_cell_atlas_coords(map_coord) == BRICK_WALL:
				if can_shoot:
					can_shoot = false
					can_move = false
					shooting_timer.start()

					var bullet_scene = BULLET.instantiate()
					bullet_scene.position = position
					bullet_scene.target_position = ray_cast_2d.get_collision_point()
					bullet_scene.tile_coordinate = map_coord
					bullet_scene.rotation = ray_cast_2d.rotation

					get_parent().add_child(bullet_scene)


	var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var direction = target_position - position

	var target_rotation = direction.angle() + PI / 2

	var rotation_value = lerp_angle(sprite_2d.rotation, target_rotation, 10 * delta)
	sprite_2d.rotation = rotation_value
	collision_shape_2d.rotation = rotation_value
	ray_cast_2d.rotation = rotation_value

	velocity = velocity.move_toward(direction.normalized() * speed, acceleration * delta)

	move_and_slide()


func _on_shotting_timer_timeout() -> void:
	can_shoot = true
	can_move = true
