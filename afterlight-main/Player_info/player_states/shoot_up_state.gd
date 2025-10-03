extends NodeState

var bullet  =  preload("res://Player_info/bullet.tscn")
@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var muzzle : Marker2D
@export var hold_gun_time : float = 2.0
var muzzle_position : Vector2

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	if GameInputEvents.shoot_up_input():
		gun_muzzle_position()
		gun_shooting()
		
	#transition states
	
	# run state
	var direction :  float = GameInputEvents.movement_input()
	
	if direction and character_body_2d.is_on_floor():
		transition.emit("run")
	# jump state
	if GameInputEvents.jump_input():
		transition.emit("jump")
	
func enter():
	muzzle.position = Vector2(4, -42)
	muzzle_position = muzzle.position
	# create timer so after shooting the player goes back to idle state
	get_tree().create_timer(hold_gun_time).timeout.connect(on_hold_gun_timeout)
	animated_sprite_2d.play("shoot_up")
	


func gun_shooting():
	var direction : float  = -1 if animated_sprite_2d.flip_h == true else 1
	
	#instantiate bullet
	var bullet_instance = bullet.instantiate() as Node2D
	# pass direction to bullet instance
	bullet_instance.direction = -1
	bullet_instance.move_x_direction = false
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
	
func gun_muzzle_position():
	if !animated_sprite_2d.flip_h:
		muzzle.position.x = muzzle_position.x
	else:
		muzzle.position.x = -muzzle_position.x	
	
func on_hold_gun_timeout():
	transition.emit("idle")

func exit():
	animated_sprite_2d.stop()
