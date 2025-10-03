extends NodeState

var bullet = preload("res://Player_info/bullet.tscn")
@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var muzzle : Marker2D
@onready var gun_sprite: Sprite2D = $"../../Gun"

@export var gun_sprite_base_position: Vector2 = Vector2(15, -10)


var muzzle_position : Vector2
var time_since_last_shot: float = 0.0
var fire_rate: float = 0.15 
var bullet_speed : int = 800

func on_process(delta : float):
	time_since_last_shot += delta
	
func on_physics_process(_delta : float):
	gun_muzzle_position(0)
	

	

	var direction : float = GameInputEvents.movement_input()
	if direction != 0:

		if Input.is_action_pressed("shoot"):
			transition.emit("run_and_gun")

		else:
			transition.emit("run")
		return


	if GameInputEvents.jump_input():
		transition.emit("jump")
		return
	

	if !Input.is_action_pressed("shoot"):
		transition.emit("idle")
		return


	if Input.is_action_pressed("shoot") and time_since_last_shot >= fire_rate:
		gun_shooting()


	character_body_2d.velocity.x = 0
	character_body_2d.move_and_slide()
	
func enter():
	muzzle.position = Vector2(15, -10)
	muzzle_position = muzzle.position
	animated_sprite_2d.play("shoot_stand")
	gun_sprite.visible = true
	time_since_last_shot = fire_rate 
	
func exit():
	animated_sprite_2d.stop()
	gun_sprite.visible = false

func gun_shooting():
	time_since_last_shot = 0.0
	
	var velocity_direction = Vector2.RIGHT
	if animated_sprite_2d.flip_h:
		velocity_direction = Vector2.LEFT
		
	var bullet_instance = bullet.instantiate()
	bullet_instance.set_velocity_bullet(velocity_direction * bullet_speed)
	
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
	
func gun_muzzle_position(_direction : float):

	if !animated_sprite_2d.flip_h:
		muzzle.position.x = muzzle_position.x
		gun_sprite.position = gun_sprite_base_position
		gun_sprite.flip_h = false
	else:
		muzzle.position.x = -muzzle_position.x
		gun_sprite.position = Vector2(-gun_sprite_base_position.x, gun_sprite_base_position.y)
		gun_sprite.flip_h = true
