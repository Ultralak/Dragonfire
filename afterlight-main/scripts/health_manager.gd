extends Node

var max_health : int = 1000
var current_health : int

signal on_health_change

func _ready():
	current_health = max_health
	
func decrease_health(health_amount : int):
	current_health -= health_amount
	
	if current_health < 0:
		current_health = 0
	print("decrease_health_called")
	on_health_change.emit(current_health)
	
func increase_health(health_amount : int):
	current_health += health_amount
	
	if current_health > max_health:
		current_health = max_health
	print("increase_health_called")
	on_health_change.emit(current_health)
