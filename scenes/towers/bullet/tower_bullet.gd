extends Area2D
class_name TowerBullet

var target_position: Vector2
var speed: int = 300
var direction: Vector2
var life_time: float


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
	queue_free()


func _process(delta: float) -> void:
	life_time += delta
	if life_time >= 2:
		call_deferred(&"queue_free")
		return

	if direction == Vector2.ZERO:
		direction = (target_position - position).normalized()
	position += direction * speed * delta
