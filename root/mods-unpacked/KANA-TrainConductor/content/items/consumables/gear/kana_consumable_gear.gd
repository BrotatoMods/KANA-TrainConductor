extends Consumable


onready var animation_player: AnimationPlayer = $"%AnimationPlayer"


func _ready() -> void:
	animation_player.play("fade_in")