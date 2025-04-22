extends Node2D

@export var stats : StatSheet

var player: Node
var turret_area: Node
var destroyed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../Player")
	turret_area = get_node("TurretArea")
	print("curr life: ", stats.life)
	if player == null:
		print("No player detected!")
		get_tree().quit(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not destroyed:
		$TurretArea.look_at(player.position)


func _on_turret_body_entered(body: Node2D) -> void:
	var grps = body.get_groups()
	if "Player" in grps:
		stats.life -= body.stats.damage
		print("Bodyslam!!! Curr life: ", stats.life)
		if stats.life <= 0:
			turret_area.queue_free()
			destroyed = true
