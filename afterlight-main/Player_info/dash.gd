extends NodeState

@export var dash_speed: float = 1200.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 5.0

@export var player: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var dash_duration_timer: Timer
@export var dash_cooldown_timer: Timer

var dash_direction: Vector2 = Vector2.RIGHT
var is_on_cooldown: bool = false

# Renamed initialize() to _ready() and removed arguments.
# This ensures it runs only once when the scene loads.
func _ready():
	# Check if the required nodes have been assigned in the inspector
	if dash_duration_timer:
		dash_duration_timer.wait_time = dash_duration
		dash_duration_timer.timeout.connect(_on_dash_duration_timer_timeout)
	
	if dash_cooldown_timer:
		dash_cooldown_timer.wait_time = dash_cooldown
		dash_cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

# The initialize function is removed, and the main player script must now connect 
# the exported properties in the inspector instead of calling initialize().

func enter():
	# Check if the cooldown is active. Use one line for early exit.
	if is_on_cooldown:
		transition.emit("idle")
		
	var horizontal_input = GameInputEvents.movement_input()
	
	# Determine dash direction based on input or current facing direction
	if horizontal_input != 0:
		dash_direction = Vector2(horizontal_input, 0)
	elif animated_sprite.flip_h:
		dash_direction = Vector2.LEFT
	else:
		dash_direction = Vector2.RIGHT
		
	is_on_cooldown = true
	dash_cooldown_timer.start()
	dash_duration_timer.start()
	
	animated_sprite.play("dash")
	player.velocity.y = 0 
	player.velocity.x = dash_direction.x * dash_speed
	
	return null

func exit():
	player.velocity.x = 0
	animated_sprite.stop()
	return null

func on_physics_process(_delta: float):
	player.velocity.x = dash_direction.x * dash_speed
	player.move_and_slide()
	return null

func _on_dash_duration_timer_timeout():
	if player.is_on_floor():
		transition.emit("idle")
	else:
		transition.emit("fall")

func _on_cooldown_timer_timeout():
	is_on_cooldown = false

func can_dash() -> bool:
	return !is_on_cooldown
