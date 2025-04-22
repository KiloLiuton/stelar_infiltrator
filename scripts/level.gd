extends Node2D

# Playable area
const BORDER_TOP = 100
const BORDER_BOTTOM = 100
const BORDER_LEFT = 200
const BORDER_RIGHT = 200


func _ready() -> void:
	print("Hi from level! ")


func _process(delta: float) -> void:
	if Input.is_action_pressed("quit"):
		get_tree().quit(0)
