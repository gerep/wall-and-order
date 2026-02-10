extends StaticBody2D
class_name Tower

@onready var area2D: Area2D = $Area2D
@onready var shooting_timer: Timer = $ShootingTimer

const BULLET_SCENE = preload("uid://ce2yywdbrmmiv")
const TOWER_SHOOTING_SOUND: AudioStream = preload("uid://luobllha83oh")

var targets: Array[Node2D]


func _ready() -> void:
	area2D.body_entered.connect(_on_body_entered)
	area2D.body_exited.connect(_on_body_exited)
	shooting_timer.timeout.connect(_on_shooting_timer_timeout)


func _shoot() -> void:
	if targets.is_empty():
		return

	AudioManager.play(TOWER_SHOOTING_SOUND)
	var bullet_scene: TowerBullet = BULLET_SCENE.instantiate()
	bullet_scene.target_position = targets[0].global_position
	get_parent().call_deferred("add_child", bullet_scene)
	bullet_scene.position = position


func _on_body_entered(body: Node2D) -> void:
	targets.push_back(body)


func _on_body_exited(body: Node2D) -> void:
	targets.erase(body)


func _on_shooting_timer_timeout() -> void:
	_shoot()
