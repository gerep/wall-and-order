extends Area2D
class_name TowerBullet

@onready var sprite: Sprite2D = $Sprite2D

var target_position: Vector2
var speed: int = 300
var direction: Vector2
var life_time: float


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method(&"take_damage"):
		body.take_damage()

	queue_free()


func _process(delta: float) -> void:
	life_time += delta
	if life_time >= 2:
		call_deferred(&"queue_free")
		return

	if direction == Vector2.ZERO:
		direction = (target_position - position).normalized()

	sprite.rotation = direction.angle()
	position += direction * speed * delta
