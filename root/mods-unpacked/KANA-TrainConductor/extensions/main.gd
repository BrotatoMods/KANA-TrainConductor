extends "res://main.gd"


var KANA_log_name := "KANA-TrainConductor"
var KANA_timespan_timer : Node

onready var KANA_Train_Conductor = get_node("/root/ModLoader/KANA-TrainConductor")


func init_camera() -> void:
	.init_camera()

	if RunData.current_character.my_id == "character_train_conductor":
		_camera.zoom = Vector2(1.6, 1.6)
		_camera.center_vertical = true
		_camera.center_horizontal = true
		# _camera.limit_right = max_pos.x + EDGE_SIZE
		# I could take some time to figure out how to calculate this,
		# but the camera is fixed anyway, so I can also just keep the hardcoded number here that centers it. ¯\_ツ)_/¯
		_camera.limit_right = 2570


func on_consumable_picked_up(consumable:Node) -> void:
	.on_consumable_picked_up(consumable)

	if consumable.consumable_data.my_id == "kana_consumable_gear":
		KANA_Train_Conductor.play_sfx()
		# Increase the gears collected counter
		RunData.tracked_item_effects["character_train_conductor"] += 1
