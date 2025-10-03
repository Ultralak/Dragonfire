extends CharacterBody2D

signal health_changed(new_health: int)

@onready var healthbar: ProgressBar = $Healthbar

@export var max_health : int = 600
@export var damage_amount : float = 100


var enemy_death_effect = preload("res://enemy_stuff/enemy_death_effect.tscn")
var current_health : int

func _ready() -> void:
	current_health = max_health
	healthbar.health_source = self
	healthbar.init_health(max_health, current_health)
	
func take_damage(damage: int):
	current_health = max(0, current_health - damage)
	
	health_changed.emit(current_health)
	
	print("Health amount: ", current_health)
	if current_health <= 0:
		var enemy_death_fx_instance = enemy_death_effect.instantiate()
		enemy_death_fx_instance.global_position = global_position
		get_parent().add_child(enemy_death_fx_instance)
		queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("Hurtbox area entered")
	
	var damage = 0
	
	if area.get_parent() and area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		damage = node.get_damage_amount()
	
	if damage > 0:
		take_damage(damage)
