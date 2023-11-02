extends "res://entities/structures/turret/turret.gd"


var KANA_tween: Tween
var KANA_just_spawned := true
var KANA_movement_direction: Vector2


func _ready():
	KANA_add_walking_turret()

	if RunData.effects["kana_turret_follow_player"]:
		KANA_tween = Tween.new()
		add_child(KANA_tween)

	if RunData.effects["kana_turret_collide_with_player"]:
		KANA_setup_collision()


func KANA_tween_global_position(to: Vector2):
	KANA_movement_direction = global_position.direction_to(to)
	# If the distance to `to` is this heigh the character propably did port
	if global_position.distance_squared_to(to) > 300000 and not KANA_just_spawned:
		global_position = to
	else:
		KANA_update_animation(KANA_movement_direction)
		KANA_tween.interpolate_property(self, "global_position", global_position, to, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		KANA_tween.start()
		if KANA_just_spawned:
			KANA_just_spawned = false


func KANA_setup_collision():
	collision_layer = 8
	collision_mask = 2


func KANA_add_walking_turret() -> void:
	var turret_legs: Node = preload("res://mods-unpacked/KANA-TrainConductor/custom_scenes/Turret_legs.tscn").instance()
	var turret_particles: Node = preload("res://mods-unpacked/KANA-TrainConductor/custom_scenes/Turret_particles.tscn").instance()
	var turret_walking_animation: Resource = preload("res://mods-unpacked/KANA-TrainConductor/custom_resources/move.tres")
	var turret_death_animation: Resource = preload("res://mods-unpacked/KANA-TrainConductor/custom_resources/death.tres")
	var turret_walking_sprite: Resource = preload("res://mods-unpacked/KANA-TrainConductor/custom_resources/turret_moving-bodies/turret.png")

	# Add particles
	.add_child(turret_particles)
	.move_child(turret_particles, 0)

	# Override the base sprite
	var texure_path: String = sprite.texture.resource_path
	var texture_name: String = texure_path.get_file()

	# Check if turret requires legs
	if (
		texture_name == "turret.png" or
		texture_name == "flame_turret.png" or
		texture_name == "healing_turret.png" or
		texture_name == "laser_turret.png" or
		texture_name == "rocket_turret.png"
	):
		sprite.texture = load("res://mods-unpacked/KANA-TrainConductor/custom_resources/turret_moving-bodies/%s" % texture_name)

		# Add the legs
		_animation.add_child(turret_legs)
		_animation.move_child(turret_legs, 0)

		# Add walking animation
		_animation_player.add_animation('move', turret_walking_animation)
		_animation_player.play("move")

		# Replace death animation
		_animation_player.remove_animation('death')
		_animation_player.add_animation('death', turret_death_animation)


func KANA_update_animation(movement:Vector2)-> void:
		if movement.x > 0:
			sprite.scale.x = abs(sprite.scale.x)
		elif movement.x < 0:
			sprite.scale.x = - abs(sprite.scale.x)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	._on_AnimationPlayer_animation_finished(anim_name)
	_animation_player.play("move")
