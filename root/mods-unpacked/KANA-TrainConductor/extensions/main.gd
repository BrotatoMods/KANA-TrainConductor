extends "res://main.gd"


var KANA_log_name := "KANA-TrainConductor"
var KANA_Train_Conductor: Node
var KANA_timespan_timer : Node


func _ready() -> void:
	KANA_Train_Conductor = get_node("/root/ModLoader/KANA-TrainConductor")
	KANA_add_timers_to_main()

	if RunData.effects["kana_spawn_gear_consumable"]:
		KANA_spawn_gear()

	_player.connect("KANA_last_position_updated", self, "_KANA_on_last_position_updated")
	_entity_spawner.connect("structure_spawned", self, "_KANA_on_structure_spawned")
	_wave_timer.connect("timeout", self, "_KANA_on_wave_timer_timeout")
	KANA_timespan_timer.connect("timeout", self, "_KANA_on_timespan_timer_timeout")

	# Clear turret array on wave start
	KANA_Train_Conductor.KANA_turrets.clear()

	if KANA_Train_Conductor.KANA_draw_debug_point:
		KANA_Train_Conductor.KANA_debug_points = Node.new()
		KANA_Train_Conductor.KANA_debug_points.name = "KANADebugPoints"
		add_child(KANA_Train_Conductor.KANA_debug_points, true)


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


func KANA_create_temp_effect_timer(key: String, value: int, seconds: int) -> void:
	ModLoaderLog.debug("Adding effect -> %s with value -> %s" % [key, value], KANA_log_name)
	ModLoaderLog.debug("Current effect value of -> %s is -> %s" % [key, str(RunData.effects[key])], KANA_log_name)
	KANA_timespan_timer.KANA_create_temp_timer(key, value, seconds)


func KANA_create_temp_stat_timer(key: String, value: int, seconds: int) -> void:
	TempStats.add_stat(key, value)
	ModLoaderLog.debug("Added stat -> %s with value -> %s" % [key, value], KANA_log_name)
	ModLoaderLog.debug("Current stat value of -> %s is -> %s" % [key, str(TempStats.get_stat(key))], KANA_log_name)
	var timer := get_tree().create_timer(seconds)
	timer.connect("timeout", self, "_KANA_on_temp_stat_timer_timeout", [key, value, seconds])


func KANA_draw_debug_points() -> void:
	# Remove all points
	for child in KANA_Train_Conductor.KANA_debug_points.get_children():
		KANA_Train_Conductor.KANA_debug_points.remove_child(child)
		child.queue_free()

	# Add all points ¯\_ツ)_/¯
	for position in _player.KANA_last_positions:
		var new_debug_point : Node2D = KANA_Train_Conductor.KANA_debug_point.instance()
		KANA_Train_Conductor.KANA_debug_points.add_child(new_debug_point)
		new_debug_point.global_position = position


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


func KANA_add_timers_to_main() -> void:
	KANA_timespan_timer = preload("res://mods-unpacked/KANA-TrainConductor/custom_scenes/time_span_timer.tscn").instance()
	.add_child(KANA_timespan_timer)


func _KANA_on_last_position_updated(last_position: Vector2) -> void:
	if KANA_Train_Conductor.KANA_draw_debug_point:
		KANA_draw_debug_points()

	for i in KANA_Train_Conductor.KANA_turrets.size():
		var turret: Node = KANA_Train_Conductor.KANA_turrets[i]
		# Check if there are enough "last position"
		if i in range(_player.KANA_last_positions.size()):
			# If so tween the global position of the turret to the last position index
			turret.KANA_tween_global_position(_player.KANA_last_positions[i])


func _KANA_on_structure_spawned(structure: Structure) -> void:
	if structure is Turret:
		# Need to use `push_front` here so new turrets move to the end and not the front.
		# Not ideal, but the array is not that large. Perhaps there's a better solution.
		KANA_Train_Conductor.KANA_turrets.push_front(structure)
		_player.KANA_update_last_positions_length()


func _KANA_on_wave_timer_timeout() -> void:
	if KANA_Train_Conductor.KANA_last_gear:
		KANA_Train_Conductor.KANA_last_gear.queue_free()
		RunData.KANA_clear_temp_items()


func _KANA_on_temp_stat_timer_timeout(key: String, value: int, seconds: int) -> void:
	TempStats.remove_stat(key, value)
	ModLoaderLog.debug("Removed stat -> %s new value is -> %s" % [key, str(TempStats.get_stat(key))], KANA_log_name)


func _KANA_on_timespan_timer_timeout(key: String, value: int, seconds: int) -> void:
	RunData.effects[key] = RunData.effects[key] - value
	ModLoaderLog.debug("Removed effect, new value of %s is -> %s" % [key, str(RunData.effects[key])], KANA_log_name)


func on_consumable_picked_up(consumable:Node) -> void:
	.on_consumable_picked_up(consumable)

	if RunData.effects["kana_temp_effect_for_time_amount"].size() > 0:
		var temp_effect := RunData.effects["kana_temp_effect_for_time_amount"].pop_back() as Array
		KANA_create_temp_effect_timer(temp_effect[0], temp_effect[1], temp_effect[2])

	if RunData.effects["kana_temp_stat_for_time_amount"].size() > 0:
		var temp_stat := RunData.effects["kana_temp_stat_for_time_amount"].pop_back() as Array
		KANA_create_temp_stat_timer(temp_stat[0], temp_stat[1], temp_stat[2])

	if consumable.consumable_data.my_id == "kana_consumable_gear":
		KANA_Train_Conductor.play_sfx()
		# Spawn a new gear
		KANA_spawn_gear()
		var KANA_turret_effect := load("res://items/all/turret/turret_effect_1.tres")
		# Spawn a turret
		_entity_spawner.queue_to_spawn_structures.push_back([EntityType.STRUCTURE, KANA_turret_effect.scene, _player.global_position, KANA_turret_effect])
		# Wiggle the trail for 5 sec.
		KANA_Train_Conductor.KANA_activate_boost()
