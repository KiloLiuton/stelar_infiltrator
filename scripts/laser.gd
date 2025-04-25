extends Node2D

var direction: Vector2
var speed = 1000.0


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	position += direction * speed * delta
	if position.length() > 2000:
		queue_free()
