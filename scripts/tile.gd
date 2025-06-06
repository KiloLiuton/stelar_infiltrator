extends Sprite2D

var turret_scene := preload("res://scenes/turret.tscn")
@onready var spawn_points: Array[Node] = $SpawnPoints.get_children()
@onready var num_spawns := len(spawn_points)


func _ready() -> void:
	spawn_points.shuffle()


func _process(_delta: float) -> void:
	pass


func spawn_enemies(n: int):
	n = min(n, num_spawns)
	print("Spawning turrets!")
	for i in range(n):
		var pos = spawn_points[i].position
		print("Spawning!", pos)
		var turret = turret_scene.instantiate()
		turret.position = pos
		add_child(turret)
