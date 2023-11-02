extends Node


const TRAIN_CONDUCTOR_MOD_DIR := "KANA-TrainConductor"
const TRAIN_CONDUCTOR_LOG_NAME := "KANA-TrainConductor"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

# --- data used by script extensions ---
var KANA_sfx: PackedScene = preload("res://mods-unpacked/KANA-TrainConductor/custom_scenes/sfx.tscn")
var KANA_sfx_player: AudioStreamPlayer
var KANA_gear_consumable = preload("res://mods-unpacked/KANA-TrainConductor/content/items/consumables/gear/gear_data.tres")
var KANA_last_gear: Node
var KANA_turrets := []
var KANA_temp_items := []
var KANA_draw_debug_point := false
var KANA_debug_points: Node
var KANA_debug_point := preload("res://mods-unpacked/KANA-TrainConductor/custom_scenes/debug_point.tscn")
var has_teleported := false
var is_boost_active := false
var boost_timer: Timer


func _init() -> void:
	ModLoaderLog.info("Init", TRAIN_CONDUCTOR_LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(TRAIN_CONDUCTOR_MOD_DIR)

	# Add extensions
	install_script_extensions()

	# Add translations
	add_translations()


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.plus_file("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("singletons/run_data.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("entities/units/player/player.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("main.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("entities/structures/turret/turret.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("entities/units/movement_behaviors/player_movement_behavior.gd"))


func add_translations() -> void:
	translations_dir_path = mod_dir_path.plus_file("translations")
	ModLoaderMod.add_translation(translations_dir_path.plus_file("translation.de.translation"))
	ModLoaderMod.add_translation(translations_dir_path.plus_file("translation.en.translation"))


func _ready() -> void:
	ModLoaderLog.info("Ready", TRAIN_CONDUCTOR_LOG_NAME)

	boost_timer = Timer.new()
	boost_timer.one_shot = true
	add_child(boost_timer)
	boost_timer.connect("timeout", self, "_on_boost_timer_timeout")

	# Add time span timer to the main scene
	KANA_add_timers_to_main()

	# Get the ContentLoader class
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	var content_dir = mod_dir_path.plus_file("content_data")

	# Add content. These .tres files are ContentData resources
	ContentLoader.load_data(content_dir.plus_file("TrainConductorContent.tres"), TRAIN_CONDUCTOR_LOG_NAME)


	KANA_sfx_player = KANA_sfx.instance()
	add_child(KANA_sfx_player)


# TODO: Move this into the main.gd extension to prevent the material UI to shift.
func KANA_add_timers_to_main() -> void:
	var main_scene = load("res://main.tscn").instance()
	var timespan_timer = load("res://mods-unpacked/KANA-TrainConductor/custom_scenes/time_span_timer.tscn").instance()

	main_scene.add_child(timespan_timer)
	timespan_timer.set_owner(main_scene)

	ModLoaderMod.save_scene(main_scene, "res://main.tscn")


func KANA_activate_boost() -> void:
	if not is_boost_active:
		is_boost_active = true

		if boost_timer.is_stopped():
			boost_timer.start(5)
		else:
			boost_timer.time_left = 5.0


func play_sfx() -> void:
	if not KANA_sfx_player.playing and not is_boost_active:
		KANA_sfx_player.pitch_scale = rand_range(0.9, 1.1)
		KANA_sfx_player.play()


func _on_boost_timer_timeout() -> void:
	is_boost_active = false
