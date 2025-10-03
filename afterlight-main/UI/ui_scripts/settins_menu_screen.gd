extends CanvasLayer
@onready var window_mode_button: OptionButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Window_mode_Button
@onready var resoulution_settings_option_button: OptionButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/resoulution_settings_OptionButton

var windows_modes : Dictionary= {"Fullscreen" : DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
									"Window" : DisplayServer.WINDOW_MODE_WINDOWED,
									"Window Maximized" : DisplayServer.WINDOW_MODE_MAXIMIZED}
var resolutions : Dictionary = { "640x360":Vector2i(640, 360),
								  "480x270":Vector2i(480, 270)}
								
func _ready() -> void:
	for window_mode in windows_modes:
		window_mode_button.add_item(window_mode)
	for resolution in resolutions: 
		resoulution_settings_option_button.add_item(resolution)
	initialise_controls()
	
func initialise_controls():
	SettingsManager.load_settings()
	var settings_data : SettingsDataResource = SettingsManager.get_settings()
	window_mode_button.selected = settings_data.window_mode_index
	resoulution_settings_option_button.selected = settings_data.resolution_index

func _on_window_mode_button_item_selected(index: int) -> void:
	var window_mode = windows_modes.get(window_mode_button.get_item_text(index)) as int
	SettingsManager.set_window_mode(window_mode, index)

func _on_resoulution_settings_option_button_item_selected(index: int) -> void:
	var resolution_mode  = resolutions.get(resoulution_settings_option_button.get_item_text(index)) as Vector2i
	SettingsManager.set_resolution(resolution_mode, index)

func _on_main_menu_button_pressed():
	SettingsManager.save_settings()
	GameManager.main_menu()
	queue_free()
