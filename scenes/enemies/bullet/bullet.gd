extends Area2D

var target_position: Vector2
var tile_coordinate: Vector2i
var speed: int = 300


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node2D) -> void:
	GameManager.tile_destroyed.emit(tile_coordinate)
	queue_free()


func _process(delta: float) -> void:
	var direction = (target_position - position).normalized()
	position += direction * speed * delta
