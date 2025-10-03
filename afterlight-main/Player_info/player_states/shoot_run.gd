extends NodeState

var bullet = preload("res://Player_info/bullet.tscn")
@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var muzzle : Marker2D
@onready var gun_sprite: Sprite2D = $"../../Gun"
@export var gun_sprite_base_position: Vector2 = Vector2(15, -10)


@export_category("Run State")
@export var speed : int = 1000
@export var max_horizontal_speed : int = 300


var muzzle_position : Vector2
var time_since_last_shot: float = 0.0
var fire_rate: float = 0.15

func on_process(delta : float):
	time_since_last_shot += delta
	

func on_physics_process(_delta : float):
	var direction : float = GameInputEvents.movement_input()
	

	gun_muzzle_position(direction)
	
	if direction:
		character_body_2d.velocity.x += direction * speed
		character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_horizontal_speed, max_horizontal_speed)
	
	if direction != 0:
		animated_sprite_2d.flip_h = false if direction > 0 else true
	

	if Input.is_action_pressed("shoot") and time_since_last_shot >= fire_rate:
		gun_shooting(direction)
		
	character_body_2d.move_and_slide()
	


	if not character_body_2d.is_on_floor():
		transition.emit("fall")
		return

	# Transition to SHOOT_STAND (Stop moving, but still shooting)
	if direction == 0 and Input.is_action_pressed("shoot"):
		transition.emit("shoot_stand")
		return


	if !Input.is_action_pressed("shoot"):
		if direction != 0:
			transition.emit("run")
		else:
			transition.emit("idle")
		return
		
	if GameInputEvents.jump_input():
		transition.emit("jump")
		return
		
func enter():
	muzzle.position = Vector2(15, -10)
	muzzle_position = muzzle.position
	animated_sprite_2d.play("idle")
	gun_sprite.visible = true
	time_since_last_shot = fire_rate 
	
func exit():
	animated_sprite_2d.stop()
	gun_sprite.visible = false

func gun_shooting(_direction : float):
	time_since_last_shot = 0.0 
	
	var bullet_instance = bullet.instantiate()
	
	var velocity_direction = Vector2.RIGHT
	if animated_sprite_2d.flip_h:
		velocity_direction = Vector2.LEFT
	
	var bullet_speed = 800
	bullet_instance.set_velocity_bullet(velocity_direction * bullet_speed)
	
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
	
func gun_muzzle_position(direction : float):
	if direction > 0:

		muzzle.position.x = muzzle_position.x
		gun_sprite.position = gun_sprite_base_position
		gun_sprite.flip_h = false
	elif direction < 0:

		muzzle.position.x = -muzzle_position.x
		gun_sprite.position = Vector2(-gun_sprite_base_position.x, gun_sprite_base_position.y)
		gun_sprite.flip_h = true
