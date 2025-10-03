extends NodeState

var bullet = preload("res://Player_info/bullet.tscn")
@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var attack_duration: float = 1.0
@onready var animation_timer: Timer = Timer.new()

@export_category("Slash State")
@export var slash_forward_force: float = 100.0

@onready var melee_hitbox_r = character_body_2d.get_node("MeleeHitBox_R")
@onready var melee_hitbox_l = character_body_2d.get_node("MeleeHitBox_L")

func _ready():
	add_child(animation_timer)
	animation_timer.one_shot = true
	animation_timer.timeout.connect(_on_animation_timer_timeout)

func on_process(_delta : float):
	pass
	
func on_physics_process(_delta : float):
	character_body_2d.move_and_slide()
	
	if not character_body_2d.is_on_floor():
		transition.emit("fall")
		return
	
func enter():
	animated_sprite_2d.play("attack_one")
	
	var direction_multiplier = 1.0
	var active_hitbox
	
	if animated_sprite_2d.flip_h:
		# Facing Left
		direction_multiplier = -1.0
		active_hitbox = melee_hitbox_l
	else:
		# Facing Right
		active_hitbox = melee_hitbox_r
		
	character_body_2d.velocity.x = slash_forward_force * direction_multiplier
	
	if active_hitbox and active_hitbox.has_method("activate_hitbox"):
		active_hitbox.activate_hitbox()
		
	animation_timer.start(attack_duration)
	
func exit():
	animated_sprite_2d.stop()
	character_body_2d.velocity.x = 0
	
	# Deactivate both hitboxes when exiting the state
	if melee_hitbox_r and melee_hitbox_r.has_method("deactivate_hitbox"):
		melee_hitbox_r.deactivate_hitbox()
	if melee_hitbox_l and melee_hitbox_l.has_method("deactivate_hitbox"):
		melee_hitbox_l.deactivate_hitbox()

func _on_animation_timer_timeout():
	transition.emit("idle")
