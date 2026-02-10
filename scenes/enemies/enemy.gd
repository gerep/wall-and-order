extends CharacterBody2D
class_name Enemy

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shooting_timer: Timer = $ShootingTimer
@onready var move_timer: Timer = $MoveTimer
@onready var cannon: Sprite2D = $Cannon
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var speed: float = 30.0
@export var wall_type: WallType = WallType.BRICK

const BRICK_WALL: Vector2i = Vector2i(3, 0)
const STONE_WALL: Vector2i = Vector2i(3, 1)
const BULLET_SCENE: PackedScene = preload("uid://pxhsie8ss6aa")
const STONE_BULLET_TEXTURE: Texture2D = preload("uid://dqs536ircbvif")
const BRICK_BULLET_TEXTURE: Texture2D = preload("uid://dtowk4p6o1vwl")

const TANK_SHOOTING_SOUND: AudioStream = preload("uid://ccsu0ih53peim")
const TANK_EXPLOSION_SOUND: AudioStream = preload("uid://5j0x8l73b277")

enum WallType { BRICK, STONE }

var tank_moving_sounds: Array[AudioStream] = [
	preload("uid://b64pcn78ijfv4"),
	preload("uid://ymdur37haxwv"),
	preload("uid://d4hbyhjhq7prm"),
	preload("uid://iefe44do260h")
]

var target_wall: Vector2i:
	get:
		match wall_type:
			WallType.STONE:
				return STONE_WALL
			_:
				return BRICK_WALL

var bullet_texture: Texture2D:
	get:
		match wall_type:
			WallType.STONE:
				return STONE_BULLET_TEXTURE
			_:
				return BRICK_BULLET_TEXTURE

var tilemap_layer: TileMapLayer
var target: Vector2
var can_shoot: bool = true
var can_move: bool = true
var life: int = 1


func take_damage(amount: int = 1) -> void:
	life -= amount
	if life <= 0:
		AudioManager.play(TANK_EXPLOSION_SOUND, -10.0)
		GameManager.enemy_died.emit()
		queue_free()


func _ready() -> void:
	navigation_agent_2d.target_position = target
	shooting_timer.timeout.connect(_on_shotting_timer_timeout)
	move_timer.timeout.connect(_on_move_timer_timeout)

	audio_stream_player.stream = tank_moving_sounds.pick_random()
	audio_stream_player.play()


func _physics_process(delta: float) -> void:
	if not can_move:
		return

	if navigation_agent_2d.is_navigation_finished():
		if position.distance_to(target) < navigation_agent_2d.target_desired_distance:
			GameManager.game_ended.emit()
		else:
			await get_tree().create_timer(0.5).timeout
			navigation_agent_2d.target_position = target
		return

	if ray_cast_2d.is_colliding():
		print(ray_cast_2d.get_collider())
		if ray_cast_2d.get_collider() is TileMapLayer:
			var map_coord = tilemap_layer.local_to_map(ray_cast_2d.get_collision_point())
			if tilemap_layer.get_cell_atlas_coords(map_coord) == target_wall:
				if can_shoot:
					can_shoot = false
					can_move = false
					shooting_timer.start()
					move_timer.start()

					var bullet_scene = BULLET_SCENE.instantiate()
					bullet_scene.texture = bullet_texture
					bullet_scene.position = position
					bullet_scene.target_position = ray_cast_2d.get_collision_point()
					bullet_scene.tile_coordinate = map_coord
					bullet_scene.rotation = ray_cast_2d.rotation

					get_parent().add_child(bullet_scene)
					AudioManager.play(TANK_SHOOTING_SOUND)

	var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var direction = target_position - position

	var target_rotation = direction.angle()

	var rotation_value = lerp_angle(sprite_2d.rotation, target_rotation, 10 * delta)
	sprite_2d.rotation = rotation_value
	collision_shape_2d.rotation = rotation_value
	cannon.rotation = rotation_value
	ray_cast_2d.rotation = rotation_value

	velocity = direction.normalized() * speed

	move_and_slide()


func _on_shotting_timer_timeout() -> void:
	can_shoot = true


func _on_move_timer_timeout() -> void:
	can_move = true
