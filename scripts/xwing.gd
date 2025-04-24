@icon("res://graphics/xwing.png")
extends Node2D

@export var stats : StatSheet

# Visual effects on ship when turning
const MAX_SKEW := 0.045
const SKEW_SPEED := 0.4
var velocity = Vector2.ZERO


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	## Process movement
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		velocity += stats.max_accel * delta * direction
		var vel = velocity.length()
		if vel > stats.max_speed:
			velocity = velocity.normalized() * stats.max_speed
	else:
		velocity = decay_vel(velocity, stats.max_accel / 3, delta)
	position = position + velocity * delta

	## Visual transformations
	if direction.x > 0:
		$PlayerImage.skew = skew_sprite($PlayerImage.skew, delta, 1)
		$PlayerImage.rotation = rotate_sprite($PlayerImage.rotation, delta, 1)
		$PlayerShadow.skew = skew_sprite($PlayerShadow.skew, delta, 1)
		$PlayerShadow.rotation = rotate_sprite($PlayerShadow.rotation, delta, 1)
	elif direction.x < 0:
		$PlayerImage.skew = skew_sprite($PlayerImage.skew, delta, -1)
		$PlayerImage.rotation = rotate_sprite($PlayerImage.rotation, delta, -1)
		$PlayerShadow.skew = skew_sprite($PlayerShadow.skew, delta, -1)
		$PlayerShadow.rotation = rotate_sprite($PlayerShadow.rotation, delta, -1)
	else:
		$PlayerImage.skew = skew_sprite_decay($PlayerImage.skew, delta)
		$PlayerImage.rotation = rotate_sprite_decay($PlayerImage.rotation, delta)
		$PlayerShadow.skew = skew_sprite_decay($PlayerShadow.skew, delta)
		$PlayerShadow.rotation = rotate_sprite_decay($PlayerShadow.rotation, delta)


func skew_sprite(s, delta, direction) -> float:
	var ds = SKEW_SPEED * delta * direction
	s = s + ds
	if s > 0:
		return min(s, MAX_SKEW)
	else:
		return max(s, -MAX_SKEW)


func skew_sprite_decay(s, delta) -> float:
	var new_s = s - sign(s) * SKEW_SPEED * delta
	if sign(new_s) != sign(s):
		return 0.0
	return new_s


func rotate_sprite(r, delta, direction) -> float:
	const max_rot = 0.06 * PI / 2
	var dr = stats.turn_rate * delta * direction
	r = r + dr
	if r > 0:
		return min(r, max_rot)
	else:
		return max(r, -max_rot)


func rotate_sprite_decay(r, delta) -> float:
	var new_r = r - sign(r) * stats.turn_rate * delta
	if sign(new_r) != sign(r):
		return 0.0
	return new_r


func decay_vel(vel: Vector2, accel, delta) -> Vector2:
	var new_len = max(vel.length() - accel * delta, 0)
	return vel.normalized() * new_len
