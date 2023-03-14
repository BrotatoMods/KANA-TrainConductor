extends "res://singletons/run_data.gd"


func init_effects()->Dictionary:
	return KANA_add_custom_effects(.init_effects())


func KANA_add_custom_effects(vanilla_effects: Dictionary) -> Dictionary:
	var custom_effects := {
		"kana_turret_follow_player": 0,
		"kana_turret_collide_with_player": 0,
		"kana_player_only_move": 0,
		"kana_player_move_four_way": 0,
	}

	return Utils.merge_dictionaries(vanilla_effects, custom_effects)
