extends CanvasLayer
@onready var collectible_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/collectible_label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CollectibleManager.on_collectible_award_recieved.connect(on_collectible_award_received)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_collectible_award_received(total_award : int) :
	collectible_label.text = str(total_award)


func _on_pause_texture_button_pressed():
	GameManager.pause_game()
