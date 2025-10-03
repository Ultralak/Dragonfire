extends ProgressBar

@onready var damagebar: ProgressBar = $damagebar
@onready var tween_timer: Timer = $Timer

@export var health_source: Node
@export var decay_speed: float = 1.0 # Speed multiplier for damage bar decay



func _ready():

	tween_timer.timeout.connect(_on_timer_timeout)
	

	if is_instance_valid(health_source):

		if health_source.has_signal("health_changed"):
			health_source.health_changed.connect(_on_health_change)
			

			if health_source.has_method("get_max_health") and health_source.has_method("get_current_health"):
				init_health(health_source.get_max_health(), health_source.get_current_health())
			else:

				init_health(health_source.max_health, health_source.current_health)
			return
	

	if is_instance_valid(HealthManager):
		HealthManager.on_health_change.connect(_on_health_change)

		init_health(HealthManager.max_health, HealthManager.current_health)
	

func init_health(max_hp: int, current_hp: int):
	max_value = max_hp
	damagebar.max_value = max_hp
	value = current_hp
	damagebar.value = current_hp




func _on_health_change(new_health: int):
	var prev_health = value 
	

	value = new_health
	

	if new_health < prev_health:

		tween_timer.stop()
		tween_timer.start()
	

	elif new_health > damagebar.value:

		damagebar.value = new_health



func _process(delta: float):

	if tween_timer.is_stopped():
		return
		

	if damagebar.value > value:

		var decay_rate = (damagebar.max_value / 2.0) * decay_speed * delta
		damagebar.value = move_toward(damagebar.value, value, decay_rate)
	

	if damagebar.value <= value:
		damagebar.value = value
		tween_timer.stop()

func _on_timer_timeout():

	pass
