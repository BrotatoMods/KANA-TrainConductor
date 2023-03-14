extends "res://entities/structures/turret/turret.gd"


var KANA_tween : Tween


func _ready():
	KANA_tween = Tween.new()
	add_child(KANA_tween)


func KANA_tween_global_position(to: Vector2):
	KANA_tween.interpolate_property(self, "global_position", global_position, to, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	KANA_tween.start()
