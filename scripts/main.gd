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
var tile_scene = preload("res://scenes/tile.tscn")

@onready var screen_size = get_viewport_rect().size
@onready var top_left = Vector2(BORDER_LEFT, BORDER_TOP)
@onready var bot_right = Vector2(screen_size.x - BORDER_RIGHT, screen_size.y - BORDER_BOTTOM)
@onready var player = spawn_player(&"xwing")
@onready var weapon_slot = 0
@onready var weapons = player.get_node("WeaponPoints").get_children()
@onready var num_weapons = len(weapons)
var tiles: Array[Node] = []


func _ready() -> void:
	print("Hi from level! ")
	spawn_tile(0)
	# Fix the position of the first tile so that it starts covering the screen
	tiles[0].position += Vector2(0.0, screen_size.y)

var s = 0
func _process(delta: float) -> void:
	## Move background
	for tile in tiles:
		tile.position.y += BACKGROUND_SPEED * delta
	if tile_top(tiles[0]) > 0:
		spawn_tile(2)
	if tile_top(tiles[-1]) > screen_size.y:
		tiles[-1].queue_free()
		tiles.pop_back()
	## Menu interactions
	if Input.is_action_pressed("quit"):
		get_tree().quit(0)
	## Process attack
	if Input.is_action_pressed("attack_laser") and player.laser_ready:
		laser_attack()
		player.get_node("AttackCooldown").start()
		player.laser_ready = false
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


func spawn_tile(n: int) -> void:
	var bg := tile_scene.instantiate()
	var bg_h = bg.texture.get_height()
	var bg_w = bg.texture.get_width()
	bg.position = Vector2(bg_w / 2, -bg_h / 2)
	add_child(bg)
	bg.spawn_enemies(n)
	tiles.push_front(bg)


func laser_attack() -> void:
		var laser = laser_scene.instantiate()
		laser.direction = Vector2.UP
		var weapon = weapons[weapon_slot].global_position
		weapon_slot = (weapon_slot + 1) % num_weapons
		laser.global_position = weapon
		laser.rotation = -PI / 2
		add_child(laser)


func tile_top(tile: Node) -> float:
	return tile.position.y - tile.texture.get_height() / 2
