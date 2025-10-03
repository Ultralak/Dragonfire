extends NodeState
@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export var dash_state: NodeState 

@export_category("Jump_State")
@export var jump_height : float  = -250
@export var jump_horizontal_speed : int = 500
@export var max_jump_horizontal_speed : int = 300
@export var max_jump_count : int = 2
@export var jump_gravity : int  = 1000
@export var air_friction: int = 20 

var current_jump_count : int 
var coyote_jump : bool 


func on_process(_delta : float):
	pass
	
func on_physics_process(delta : float):
	

	if GameInputEvents.dash_input() and dash_state.can_dash():
		transition.emit("dash")
		return
	

	character_body_2d.velocity.y += jump_gravity * delta
	

	var direction  = GameInputEvents.movement_input()
	
	if direction != 0:

		character_body_2d.velocity.x += direction * jump_horizontal_speed * delta 
		animated_sprite_2d.flip_h = direction < 0
	else:

		character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, air_friction * delta)
	

	character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_jump_horizontal_speed, max_jump_horizontal_speed)
	
	

	if GameInputEvents.jump_input() and current_jump_count < max_jump_count:
		character_body_2d.velocity.y = 0 
		character_body_2d.velocity.y = jump_height
		current_jump_count += 1
		

	character_body_2d.move_and_slide()


	

	if character_body_2d.velocity.y > 0 and !character_body_2d.is_on_floor():
		transition.emit("fall")
		return
		

	if character_body_2d.is_on_floor():
		current_jump_count = 0
		transition.emit("idle")
		return
		

	if GameInputEvents.wall_cling_input() and character_body_2d.is_on_wall():
		transition.emit("shoot_wall_cling")
		return


func enter():

	if character_body_2d.is_on_floor() or coyote_jump:

		if abs(GameInputEvents.movement_input()) == 0:
			character_body_2d.velocity.x = 0
			
		character_body_2d.velocity.y = 0 
		character_body_2d.velocity.y = jump_height
		current_jump_count += 1
		coyote_jump = false
		
	animated_sprite_2d.play("jump")
	
func exit():
	coyote_jump = false
	animated_sprite_2d.stop()
