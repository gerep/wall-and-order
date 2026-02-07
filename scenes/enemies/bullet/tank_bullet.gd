extends Area2D
class_name TankBullet

@onready var sprite: Sprite2D = $Sprite2D

var target_position: Vector2
var tile_coordinate: Vector2i
var speed: int = 300
var texture: Texture2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	sprite.texture = texture


func _on_body_entered(_body: Node2D) -> void:
	GameManager.tile_destroyed.emit(tile_coordinate)
	queue_free()


func _process(delta: float) -> void:
	var direction = (target_position - position).normalized()
	position += direction * speed * delta
