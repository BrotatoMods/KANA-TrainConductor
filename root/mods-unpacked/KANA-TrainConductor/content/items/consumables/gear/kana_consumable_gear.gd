extends Consumable


onready var animation_player: AnimationPlayer = $"%AnimationPlayer"
onready var kana_sprite: Sprite = $Sprite
onready var kana_collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	animation_player.play("fade_in")
	kana_sprite.material.set_shader_param("outline_color", Color("ffd929"))
	kana_collision_shape.shape.extents = Vector2(46, 46)
