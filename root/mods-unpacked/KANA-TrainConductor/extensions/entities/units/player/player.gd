extends "res://entities/units/player/player.gd"


signal KANA_last_position_updated(last_position)

var KANA_last_positions := []
var KANA_last_positions_length := 0

onready var KANA_Train_Conductor := get_node("/root/ModLoader/KANA-TrainConductor")


func _ready():
	KANA_update_last_positions_length()


func _physics_process(delta: float) -> void:
	if RunData.effects["kana_turret_follow_player"]:
		create_trailing_points()


func create_trailing_points() -> void:
	if KANA_last_positions.size() <= KANA_last_positions_length:
		add_point()
	else:
		KANA_last_positions.pop_front()
		add_point()


func KANA_update_last_positions_length():
	KANA_last_positions_length = KANA_Train_Conductor.KANA_turrets.size() + 1


func add_point() -> void:
	var KANA_last_positions_size = KANA_last_positions.size()

	# If there are no points yet just add the point and return
	if KANA_last_positions_size == 0:
		KANA_last_positions.push_back(global_position)
		return

	var distance := global_position.distance_to(KANA_last_positions[KANA_last_positions_size - 1])
	# Check if last point has a distance of 50
	if distance < 50:
		return

	KANA_last_positions.push_back(global_position)
	emit_signal("KANA_last_position_updated", global_position)
