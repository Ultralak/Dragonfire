extends Area2D

@onready var game_manager: Node = %Game_manager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	
	game_manager.add_point()
	animation_player.play("coin")
	pass 
