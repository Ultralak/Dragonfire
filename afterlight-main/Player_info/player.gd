extends CharacterBody2D

var bullet = preload("res://Player_info/bullet.tscn")
var player_death_effect = preload("res://Player_info/Player_death_effect/player_death_effect.tscn")


@onready var muzzle: Marker2D = $Muzzle
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_amount : int = 100




func player_death():
	var player_death_effect_instance = player_death_effect.instantiate() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance)
	queue_free()
	Engine.time_scale = 2.0
	get_tree().reload_current_scene()


func _on_hitbox_body_entered(body: Node2D) :
	if body.is_in_group("Enemy"):
		print("Damage taken", body.damage_amount)
		
		var tween  = get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", true, 0)
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", false, 0.2)
		
		HealthManager.decrease_health(body.damage_amount)
		
		if HealthManager.current_health == 0:
			player_death()
	
func get_damage_amount():
	return damage_amount	
