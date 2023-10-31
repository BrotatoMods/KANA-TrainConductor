extends "res://entities/structures/turret/turret.gd"


var KANA_tween: Tween
var KANA_just_spawned := true


func _ready():
	if RunData.effects["kana_turret_follow_player"]:
		KANA_tween = Tween.new()
		add_child(KANA_tween)

	if RunData.effects["kana_turret_collide_with_player"]:
		KANA_setup_collision()


func KANA_tween_global_position(to: Vector2):
	# If the distance to `to` is this heigh the character propably did port
	if global_position.distance_squared_to(to) > 300000 and not KANA_just_spawned:
		global_position = to
	else:
		KANA_tween.interpolate_property(self, "global_position", global_position, to, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		KANA_tween.start()
		if KANA_just_spawned:
			KANA_just_spawned = false


func KANA_setup_collision():
	collision_layer = 8
	collision_mask = 2
