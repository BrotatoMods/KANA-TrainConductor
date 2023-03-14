extends "res://main.gd"


func _ready():
	_player.connect("KANA_last_position_updated", self, "_on_last_position_updated")


func _on_last_position_updated(last_position: Vector2) -> void:
	for i in _entity_spawner.structures.size():
		var structure = _entity_spawner.structures[i]
		if i in range(_player.KANA_last_positions.size()):
			if structure is Turret:
				structure.KANA_tween_global_position(_player.KANA_last_positions[i])
