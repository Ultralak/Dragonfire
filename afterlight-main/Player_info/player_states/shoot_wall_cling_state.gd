extends NodeState

var bullet  =  preload("res://Player_info/bullet.tscn")
@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var muzzle : Marker2D



var wall_cling_direction  : Vector2
var muzzle_position : Vector2
func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	# where the magic happens i.e it is not stuck to the wall just stuck in the air
	character_body_2d.velocity.y = 0
	
	var direction : float = GameInputEvents.movement_input()
	
	if direction > 0 and wall_cling_direction == Vector2.ZERO:
		animated_sprite_2d.flip_h = true
		wall_cling_direction = Vector2.RIGHT
		
	if direction < 0 and wall_cling_direction == Vector2.ZERO:
		animated_sprite_2d.flip_h = false
		wall_cling_direction = Vector2.LEFT
		
	gun_muzzle_position()
	
	if GameInputEvents.shoot_input():
		
		gun_shooting()
		
	character_body_2d.move_and_slide()
	#transition states
	
	# jump state
	if GameInputEvents.jump_input():
		transition.emit("jump")
		
	# forced fall state
	if GameInputEvents.fall_input():
		transition.emit("fall")

func enter():
	muzzle.position = Vector2(21, -26)
	muzzle_position = muzzle.position
	# create timer so after shooting the player goes back to idle state

	animated_sprite_2d.play("shoot_wall_cling")
	
func exit():
	wall_cling_direction = Vector2.ZERO
	animated_sprite_2d.stop()

func gun_shooting():
	var direction : float  = -1 if animated_sprite_2d.flip_h == true else 1
	
	#instantiate bullet
	var bullet_instance = bullet.instantiate()
	# pass direction to bullet instance
	bullet_instance.direction = direction
	bullet_instance.move_x_direction = true
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
	
func gun_muzzle_position():
	if !animated_sprite_2d.flip_h:
		muzzle.position.x = muzzle_position.x
	else:
		muzzle.position.x = -muzzle_position.x	


	
	
