extends Area2D
class_name TankBullet

@onready var sprite: Sprite2D = $Sprite2D

var target_position: Vector2
var tile_coordinate: Vector2i
var speed: int = 300
var texture: Texture2D
var direction: Vector2

@export var lifetime: float = 3.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	sprite.texture = texture
	direction = (target_position - position).normalized()
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
	GameManager.tile_destroyed.emit(tile_coordinate)
	queue_free()


func _process(delta: float) -> void:
	position += direction * speed * delta
