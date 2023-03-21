extends "res://main.gd"


var KANA_Train_Conductor: Node


func _ready() -> void:
	_player.connect("KANA_last_position_updated", self, "_KANA_on_last_position_updated")
	_entity_spawner.connect("structure_spawned", self, "_KANA_on_structure_spawned")
	_wave_timer.connect("timeout", self, "_KANA_on_wave_timer_timeout")
	KANA_Train_Conductor = get_node("/root/ModLoader/KANA-TrainConductor")
	if RunData.effects["kana_spawn_gear_consumable"]:
		KANA_spawn_gear()

	# Clear turret array on wave start
	KANA_Train_Conductor.KANA_turrets.clear()


func KANA_spawn_consumable(consumable_to_spawn: ConsumableData, pos: Vector2) -> Node:
	var KANA_dist := rand_range(50, 100)
	var KANA_consumable := consumable_scene.instance()
	KANA_consumable.consumable_data = consumable_to_spawn
	KANA_consumable.global_position = pos
	_consumables_container.call_deferred("add_child", KANA_consumable)
	KANA_consumable.call_deferred("set_texture", consumable_to_spawn.icon)
	var _error := KANA_consumable.connect("picked_up", self, "on_consumable_picked_up")
	KANA_consumable.push_back_destination = Vector2(rand_range(pos.x - KANA_dist, pos.x + KANA_dist), rand_range(pos.y - KANA_dist, pos.y + KANA_dist))
	_consumables.push_back(KANA_consumable)

	return KANA_consumable


func KANA_spawn_gear() -> void:
	var offset := 50
	var random_pos := Vector2(
			rand_range(ZoneService.current_zone_min_position.x + offset, ZoneService.current_zone_max_position.x - offset),
			rand_range(ZoneService.current_zone_min_position.y + offset, ZoneService.current_zone_max_position.y - offset)
		)
	KANA_Train_Conductor.KANA_last_gear = KANA_spawn_consumable(KANA_Train_Conductor.KANA_gear_consumable, random_pos)


func _KANA_on_last_position_updated(last_position: Vector2) -> void:
	for i in KANA_Train_Conductor.KANA_turrets.size():
		var turret := KANA_Train_Conductor.KANA_turrets[i] as Node
		if i in range(_player.KANA_last_positions.size()):
			turret.KANA_tween_global_position(_player.KANA_last_positions[i])


func _KANA_on_structure_spawned(structure: Structure) -> void:
	if structure is Turret:
		KANA_Train_Conductor.KANA_turrets.append(structure)
		_player.KANA_update_last_positions_length()


func on_consumable_picked_up(consumable:Node) -> void:
	.on_consumable_picked_up(consumable)

	if consumable.consumable_data.my_id == "kana_consumable_gear":
		KANA_spawn_gear()
		var KANA_turret_effect := load("res://items/all/turret/turret_effect_1.tres")
		_entity_spawner.queue_to_spawn_structures.push_back([EntityType.STRUCTURE, KANA_turret_effect.scene, _player.global_position, KANA_turret_effect])


func _KANA_on_wave_timer_timeout() -> void:
	KANA_Train_Conductor.KANA_last_gear.queue_free()
	RunData.KANA_clear_temp_items()
