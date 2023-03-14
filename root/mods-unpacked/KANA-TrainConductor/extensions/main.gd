extends "res://main.gd"


var KANA_Train_Conductor


func _ready():
	_player.connect("KANA_last_position_updated", self, "_KANA_on_last_position_updated")
	_entity_spawner.connect("structure_spawned", self, "_KANA_on_structure_spawned")
	KANA_Train_Conductor = get_node("/root/ModLoader/KANA-TrainConductor")

	# Clear turret array on wave start
	KANA_Train_Conductor.KANA_turrets.clear()


func _KANA_on_last_position_updated(last_position: Vector2) -> void:
	for i in KANA_Train_Conductor.KANA_turrets.size():
		var turret = KANA_Train_Conductor.KANA_turrets[i]
		if i in range(_player.KANA_last_positions.size()):
			turret.KANA_tween_global_position(_player.KANA_last_positions[i])


func _KANA_on_structure_spawned(structure: Structure) -> void:
	if structure is Turret:
		KANA_Train_Conductor.KANA_turrets.append(structure)
