extends Node2D

@export var BACKGROUND_SPEED := 100

# Playable area relative to screen size
const BORDER_TOP = 100
const BORDER_BOTTOM = 100
const BORDER_LEFT = 50
const BORDER_RIGHT = 50

# Available ships
var xwing_scene = preload("res://scenes/ships/xwing.tscn")

# Spawned scenes
var laser_scene = preload("res://scenes/laser.tscn")

@onready var screen_size = get_viewport_rect().size
@onready var top_left = Vector2(BORDER_LEFT, BORDER_TOP)
@onready var bot_right = Vector2(screen_size.x - BORDER_RIGHT, screen_size.y - BORDER_BOTTOM)
@onready var player = spawn_player(&"xwing")
@onready var weapon_slot = 0
@onready var weapons = player.get_node("WeaponPoints").get_children()
@onready var num_weapons = len(weapons)


func _ready() -> void:
	$Background.spawn_turret(1)
	print("Hi from level! ")


func _process(delta: float) -> void:
	## Move background
	$Background.position += Vector2.DOWN * delta * 100
	## Spawn enemies
	## Menu interactions
	if Input.is_action_pressed("quit"):
		get_tree().quit(0)
	## Process attack
	if Input.is_action_just_pressed("attack_laser"):
		var laser = laser_scene.instantiate()
		laser.direction = Vector2.UP
		var weapon = weapons[weapon_slot].global_position
		weapon_slot = (weapon_slot + 1) % num_weapons
		laser.global_position = weapon
		laser.rotation = -PI / 2
		add_child(laser)
	## Constrain player
	if player.position.x < top_left.x:
		player.velocity.x = 0
		player.position.x = top_left.x
	elif player.position.x > bot_right.x:
		player.velocity.x = 0
		player.position.x = bot_right.x
	if player.position.y < top_left.y:
		player.velocity.y = 0
		player.position.y = top_left.y
	if player.position.y > bot_right.y:
		player.velocity.y = 0
		player.position.y = bot_right.y


func spawn_player(ship_name: StringName) -> Node:
	var p: Node
	match ship_name:
		&"xwing":
			p = xwing_scene.instantiate()
			print(ship_name, " I choose you!")
		_:
			print("No ship I choose you!")
	add_child(p)
	screen_size = get_viewport_rect().size
	p.global_position = Vector2(screen_size.x/2, screen_size.y - BORDER_BOTTOM*2)
	p.velocity = Vector2.ZERO
	return p
