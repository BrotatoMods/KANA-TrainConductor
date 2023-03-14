extends Node


const TRAIN_CONDUCTOR_MOD_DIR := "KANA-TrainConductor"
const TRAIN_CONDUCTOR_LOG_NAME := "KANA-TrainConductor"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


func _init(modLoader = ModLoader) -> void:
	ModLoaderUtils.log_info("Init", TRAIN_CONDUCTOR_LOG_NAME)
	mod_dir_path = modLoader.UNPACKED_DIR.plus_file(TRAIN_CONDUCTOR_MOD_DIR)

	# Add extensions
	install_script_extensions(modLoader)

	# Add translations
	add_translations(modLoader)


func install_script_extensions(modLoader) -> void:
	extensions_dir_path = mod_dir_path.plus_file("extensions")
	modLoader.install_script_extension(extensions_dir_path.plus_file("singletons/run_data.gd"))
	modLoader.install_script_extension(extensions_dir_path.plus_file("entities/units/player/player.gd"))
	modLoader.install_script_extension(extensions_dir_path.plus_file("main.gd"))
	modLoader.install_script_extension(extensions_dir_path.plus_file("entities/structures/turret/turret.gd"))


func add_translations(modLoader) -> void:
	translations_dir_path = mod_dir_path.plus_file("translations")
	modLoader.add_translation_from_resource(translations_dir_path.plus_file("translation.de.translation"))
	modLoader.add_translation_from_resource(translations_dir_path.plus_file("translation.en.translation"))


func _ready() -> void:
	ModLoaderUtils.log_info("Ready", TRAIN_CONDUCTOR_LOG_NAME)

	# Get the ContentLoader class
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	var content_dir = mod_dir_path.plus_file("content_data")

	# Add content. These .tres files are ContentData resources
	ContentLoader.load_data(content_dir.plus_file("TrainConductorContent.tres"), TRAIN_CONDUCTOR_LOG_NAME)
