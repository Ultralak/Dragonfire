extends Area2D

@onready var player: CharacterBody2D = $".."

@export var damage_amount : float = 100
@export var player_reference: CharacterBody2D
var is_active: bool = false

func _ready():
	monitoring = false
	monitorable = false

func activate_hitbox():
	
	monitoring = true
	monitorable = true
	is_active = true

func deactivate_hitbox():
	
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	is_active = false
	


func get_damage_amount() -> float:
	return damage_amount


func _on_area_entered(body: Area2D) -> void:
	if is_active and body.is_in_group("Enemy"):

		if body.get_parent().has_method("take_damage"):
			var damage_to_deal = 3
			body.get_parent().take_damage(damage_to_deal)
			

		deactivate_hitbox()
