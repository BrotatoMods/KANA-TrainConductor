extends "res://singletons/run_data.gd"


onready var KANA_Train_Conductor := get_node("/root/ModLoader/KANA-TrainConductor")


func init_effects()->Dictionary:
	return KANA_add_custom_effects(.init_effects())


func init_tracked_effects() -> Dictionary:
	var vanilla = .init_tracked_effects()
	var custom_tracker = {
		"character_train_conductor": 0,
	}

	vanilla.merge(custom_tracker)

	return vanilla


func KANA_add_custom_effects(vanilla_effects: Dictionary) -> Dictionary:
	var custom_effects := {
		"kana_turret_follow_player": 0,
		"kana_turret_collide_with_player": 0,
		"kana_cant_stop_moving": 0,
		"kana_move_four_ways": 0,
		"kana_spawn_gear_consumable": 0,
		"kana_temp_stat_for_time_amount": [],
		"kana_temp_effect_for_time_amount": [],
	}

	return Utils.merge_dictionaries(vanilla_effects, custom_effects)


# Currently not used, because I can't just add the turret item and it spawns.
# But maybe useful later.
func KANA_add_temp_item(item: ItemData) -> void:
	KANA_Train_Conductor.KANA_temp_items.append(item)
	.add_item(item)


func KANA_clear_temp_items() -> void:
	for item in KANA_Train_Conductor.KANA_temp_items:
		.remove_item(item)

	KANA_Train_Conductor.KANA_temp_items.clear()
