extends Node2D

@export var stats : StatSheet

@onready var laser = preload("res://scenes/laser.tscn")
@onready var target = get_node("../../XWing")
@onready var main := get_parent()
var turret_area: Node
var cooldown := 0.0



func _ready() -> void:
	stats = stats.duplicate()
	turret_area = get_node("TurretArea")


func _process(delta: float) -> void:
	if stats.life > 0:
		cooldown += delta
		if cooldown > stats.attack_time:
			fire(target)
			cooldown = 0
		$TurretArea.look_at(target.position)


func _on_turret_area_area_entered(area: Area2D) -> void:
	var grps = area.get_groups()
	if "Projectiles" in grps:
		stats.life -= 1
		print("curr life: ", stats.life)
		if stats.life <= 0:
			turret_area.queue_free()
		area.get_parent().queue_free()


func fire(tgt) -> void:
	print("Turret firing at ", tgt, "!")
