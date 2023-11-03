extends Node


const TRAIN_CONDUCTOR_MOD_DIR := "KANA-TrainConductor"
const TRAIN_CONDUCTOR_LOG_NAME := "KANA-TrainConductor"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

# --- data used by script extensions ---
var KANA_sfx: PackedScene = preload("res://mods-unpacked/KANA-TrainConductor/custom_scenes/sfx.tscn")
var KANA_sfx_player: AudioStreamPlayer

onready var KANA_bfx := get_node("/root/ModLoader/KANA-BFX")


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

	# Get the ContentLoader class
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	var content_dir = mod_dir_path.plus_file("content_data")

	# Add content. These .tres files are ContentData resources
	ContentLoader.load_data(content_dir.plus_file("TrainConductorContent.tres"), TRAIN_CONDUCTOR_LOG_NAME)

	KANA_sfx_player = KANA_sfx.instance()
	add_child(KANA_sfx_player)


func play_sfx() -> void:
	if not KANA_sfx_player.playing and not KANA_bfx.state.walking_turrets.boost_active:
		KANA_sfx_player.pitch_scale = rand_range(0.9, 1.1)
		KANA_sfx_player.play()
