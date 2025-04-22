extends CharacterBody2D

@export var stats : StatSheet
var level: Node

var screen_size: Vector2
var top_left: Vector2
var bot_right: Vector2

# Visual effects on ship when turning
const MAX_SKEW = 0.045
const SKEW_SPEED = 0.4


func _ready() -> void:
	level = get_node("../")
	screen_size = get_viewport_rect().size
	top_left = Vector2(level.BORDER_LEFT, level.BORDER_TOP)
	bot_right = Vector2(screen_size.x - level.BORDER_RIGHT, screen_size.y - level.BORDER_BOTTOM)
	print("Hi from player! ", bot_right)
	velocity = Vector2.ZERO
	position = Vector2(screen_size.x/2, screen_size.y - level.BORDER_BOTTOM)



func _process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity += stats.max_accel * delta * direction
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
		if direction.y == 0:
			velocity = decay_vel(velocity, stats.max_accel / 3, delta)
		$PlayerImage.skew = skew_sprite_decay($PlayerImage.skew, delta)
		$PlayerImage.rotation = rotate_sprite_decay($PlayerImage.rotation, delta)
		$PlayerShadow.skew = skew_sprite_decay($PlayerShadow.skew, delta)
		$PlayerShadow.rotation = rotate_sprite_decay($PlayerShadow.rotation, delta)
	var vel = velocity.length()
	if vel > stats.max_speed:
		velocity = velocity.normalized() * stats.max_speed
	position = position + velocity * delta
	if position.x < top_left.x:
		velocity.x = 0
		position.x = top_left.x
	elif position.x > bot_right.x:
		velocity.x = 0
		position.x = bot_right.x
	if position.y < top_left.y:
		velocity.y = 0
		position.y = top_left.y
	if position.y > bot_right.y:
		velocity.y = 0
		position.y = bot_right.y


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
