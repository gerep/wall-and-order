extends Node2D

@onready var target: Marker2D = $Target
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

const BASIC_ENEMY = preload("uid://bke42ss266g4p")

var screen_width: float


func _ready() -> void:
	var asd = get_viewport_rect()
	screen_width = asd.size.x
	enemy_spawn_timer.timeout.connect(_spawn_enemy)


func _spawn_enemy() -> void:
	var spawn_position: float = randf_range(10.0, screen_width - 10)
	var enemy = BASIC_ENEMY.instantiate()
	enemy.target = target.position
	add_child(enemy)
	enemy.position = Vector2(spawn_position, -50.0)
