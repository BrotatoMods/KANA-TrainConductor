extends Node


const TRAIN_CONDUCTOR_MOD_DIR := "KANA-TrainConductor"
const TRAIN_CONDUCTOR_LOG_NAME := "KANA-TrainConductor"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

# --- data used by script extensions ---
var KANA_gear_consumable = preload("res://mods-unpacked/KANA-TrainConductor/content/items/consumables/gear/gear_data.tres")
var KANA_last_gear: Node
var KANA_turrets := []
var KANA_temp_items := []


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

	# Add time span timer to the main scene
	KANA_add_timers_to_main()

	# Get the ContentLoader class
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	var content_dir = mod_dir_path.plus_file("content_data")

	# Add content. These .tres files are ContentData resources
	ContentLoader.load_data(content_dir.plus_file("TrainConductorContent.tres"), TRAIN_CONDUCTOR_LOG_NAME)


func KANA_add_timers_to_main() -> void:
	var main_scene = load("res://main.tscn").instance()
	var timespan_timer = load("res://mods-unpacked/KANA-TrainConductor/custom_scenes/time_span_timer.tscn").instance()

	main_scene.add_child(timespan_timer)
	timespan_timer.set_owner(main_scene)

	ModLoaderMod.save_scene(main_scene, "res://main.tscn")
