extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var target: Vector2
@export var speed: float = 100.0
@export var acceleration: float = 500.0
@export var friction: float = 2000.0


func _ready() -> void:
	navigation_agent_2d.target_position = target


func _physics_process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return

	var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var direction = target_position - position

	var target_rotation = direction.angle() + PI / 2
	sprite_2d.rotation = lerp_angle(sprite_2d.rotation, target_rotation, 10 * delta)

	velocity = velocity.move_toward(direction.normalized() * speed, acceleration * delta)

	move_and_slide()
