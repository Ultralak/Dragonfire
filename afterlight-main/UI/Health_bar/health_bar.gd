extends Node2D

@export var heart_f : Texture2D
@export var heart_half : Texture2D
@export var heart_0 : Texture2D

@onready var heart_full: Sprite2D = $Heart_full
@onready var heart_full_2: Sprite2D = $Heart_full2
@onready var heart_full_3: Sprite2D = $Heart_full3

func _ready():
	HealthManager.on_health_change.connect(on_player_health_change)
	
	
func on_player_health_change(player_current_health : int):
	# this changes the icons per healthbar icons on screen
	## change to deadcells format ##
	if player_current_health == 6:
		heart_full_3.texture = heart_f
	elif player_current_health == 5:
		heart_full_3.texture = heart_half
	else:
		heart_full_3.texture = heart_0
	
	if player_current_health >= 4:
		heart_full_2.texture = heart_f
	elif player_current_health == 3:
		heart_full_2.texture = heart_half
	else:
		heart_full_2.texture = heart_0
	
	if player_current_health >= 2:
		heart_full.texture = heart_f
	elif player_current_health == 1:
		heart_full.texture = heart_half
	else:
		heart_full.texture = heart_0
