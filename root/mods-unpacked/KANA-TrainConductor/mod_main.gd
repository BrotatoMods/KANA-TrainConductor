extends Node

# ! Comments prefixed with "!" mean they are extra info. Comments without them
# ! should be kept because they give your mod structure and make it easier to
# ! read by other modders
# ! Comments with "?" should be replaced by you with the appropriate information

# ! This template file is statically typed. You don't have to do that, but it can help avoid bugs
# ! You can learn more about static typing in the docs
# ! https://docs.godotengine.org/en/3.5/tutorials/scripting/gdscript/static_typing.html

# ? Brief overview of what your mod does...

const MOD_DIR := "AuthorName-ModName" # Name of the directory that this file is in
const MODNAME_LOG_NAME := "AuthorName-ModName" # Full ID of the mod (AuthorName-ModName)

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

# ! We can't use `ModLoader` because the ModLoader instance isn't available
# ! at this point in the mod's loading process. Instead, the class instance
# ! is passed to a mod's `_init` function via the variable `modLoader`.
# ! It will be available in any other places in your mod though, such as in
# ! your _ready func.
func _init(modLoader = ModLoader) -> void:
	ModLoaderUtils.log_info("Init", MODNAME_LOG_NAME)
	mod_dir_path = modLoader.UNPACKED_DIR.plus_file(MOD_DIR)

	# Add extensions
	install_script_extensions(modLoader)

	# Add translations
	add_translations(modLoader)


func install_script_extensions(modLoader) -> void:
	# ! any script extensions should go in this directory, and should follow the same directory structure as vanilla
	extensions_dir_path = mod_dir_path.plus_file("extensions")

	# ? Brief description/reason behind this edit of vanilla code...
	modLoader.install_script_extension(extensions_dir_path.plus_file("main.gd"))
	#modLoader.install_script_extension(ext_dir + "entities/units/player/player.gd") # ! Note that this file does not exist in this example mod

	# ! Add extensions (longform version of the above)
	#modLoader.install_script_extension("res://mods-unpacked/AuthorName-ModName/extensions/main.gd")
	#modLoader.install_script_extension("res://mods-unpacked/AuthorName-ModName/extensions/entities/units/player/player.gd")


func add_translations(modLoader) -> void:
	# ! Place all of your translation files into this directory
	translations_dir_path = mod_dir_path.plus_file("translations")

	# ! Load translations for your mod, if you need them.
	# ! Add translations by adding a CSV called "modname.csv" into the "translations" directory.
	# ! Godot will automatically generate a ".translation" file, eg "modname.en.translation".
	# ! Note that in this example, only the file called "modname.csv" is custom;
	# ! any other files in the "translations" directory were automatically generated by Godot
	modLoader.add_translation_from_resource(translations_dir_path.plus_file("modname.en.translation"))



func _ready() -> void:
	ModLoaderUtils.log_info("Ready", MODNAME_LOG_NAME)

	# ! This uses Godot's native `tr` func, which translates a string. You'll
	# ! find this particular string in the example CSV here: translations/modname.csv
	ModLoaderUtils.log_info("Translation Demo: " + tr("MODNAME_READY_TEXT"), MODNAME_LOG_NAME)


