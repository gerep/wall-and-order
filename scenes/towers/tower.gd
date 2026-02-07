extends StaticBody2D

@onready var area2D: Area2D = $Area2D

const BULLET_SCENE = preload("uid://ce2yywdbrmmiv")


func _ready() -> void:
	area2D.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var bullet_scene: TowerBullet = BULLET_SCENE.instantiate()
	bullet_scene.target_position = body.position
	get_parent().call_deferred("add_child", bullet_scene)
	bullet_scene.position = position
