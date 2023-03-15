extends "res://singletons/run_data.gd"


func init_effects()->Dictionary:
	return KANA_add_custom_effects(.init_effects())


func KANA_add_custom_effects(vanilla_effects: Dictionary) -> Dictionary:
	var custom_effects := {
		"kana_turret_follow_player": 0,
		"kana_turret_collide_with_player": 0,
		"kana_cant_stop_moving": 0,
		"kana_move_four_ways": 0,
	}

	return Utils.merge_dictionaries(vanilla_effects, custom_effects)
