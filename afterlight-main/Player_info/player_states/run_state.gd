extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Run_state")
@export var speed : int = 1000
@export var max_horizontal_speed : int = 300

func on_process(_delta : float):
	pass
	
func on_physics_process(_delta : float):
	var direction : float = GameInputEvents.movement_input()
	
	if direction:
		character_body_2d.velocity.x += direction * speed
		character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_horizontal_speed, max_horizontal_speed)
		 
	if direction != 0:
		animated_sprite_2d.flip_h = false if direction > 0 else true
		
	character_body_2d.move_and_slide()

	if not character_body_2d.is_on_floor():
		transition.emit("fall")
		return
	if GameInputEvents.dash_input():
		transition.emit("dash")
		return

	if GameInputEvents.shoot_input():
		transition.emit("shoot_run")
		return
		
	if GameInputEvents.slash_input():
		transition.emit("slash")
		return


	if GameInputEvents.jump_input():
		transition.emit("jump")
		return
		

	if direction == 0:
		transition.emit("idle")
		
func enter():
	animated_sprite_2d.play("run")
	
func exit():
	animated_sprite_2d.stop()
