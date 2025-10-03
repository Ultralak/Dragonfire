extends Camera2D

@export var player : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	if player != null:
		global_position = player.global_position
