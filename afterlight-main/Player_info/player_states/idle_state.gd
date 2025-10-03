extends NodeState
@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Physcis Friction")
@export var slow_down_speed : int = 600
func on_process(_delta : float):
	pass
	
func on_physics_process(_delta : float):
	#Adds friction when the character moves/ may remove later
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, slow_down_speed)
	character_body_2d.move_and_slide()
	#transitioning state
	
	#fall state
	if !character_body_2d.is_on_floor():
		transition.emit("fall")
	
	#run state
	var direction : float = GameInputEvents.movement_input()
	if direction and character_body_2d.is_on_floor():
		transition.emit("run")
	# jump state
	
	if GameInputEvents.jump_input():
		transition.emit("jump")

	#shoot stand state
	if GameInputEvents.shoot_input():
		transition.emit("shoot_stand")
	# shoot up state
	if GameInputEvents.slash_input():
		transition.emit("slash")
	if GameInputEvents.dash_input():
		transition.emit("dash")
	
	
func enter():
	animated_sprite_2d.play("idle")
	
func exit():
	animated_sprite_2d.stop()
