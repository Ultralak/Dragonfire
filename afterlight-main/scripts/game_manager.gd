extends Node

const PAUSE_MENU_SCREEN = preload("res://UI/ui_scenes/Pause_menu_screen.tscn")
const MAIN_MENU_SCREEN = preload("res://UI/ui_scenes/main_menu_screen.tscn")
const SETTINS_MENU_SCREEN = preload("res://UI/ui_scenes/settins_menu_screen.tscn")

func _ready() :
	RenderingServer.set_default_clear_color(Color(0.44,0.12,0.53,1.00))
	SettingsManager.load_settings()

func exit_game():
	get_tree().quit()
	
func main_menu():

	if get_tree().get_root().find_child("MainMenuScreen"):
		return
		
	var main_menu_screen_instance = MAIN_MENU_SCREEN.instantiate()

	main_menu_screen_instance.name = "MainMenuScreen" 
	get_tree().get_root().add_child(main_menu_screen_instance)


func start_game():

	SceneManager.transition_to_scene("Level1")
	
func continue_game():

	var pause_menu = get_tree().get_root().find_child("PauseMenuScreen")
	if pause_menu:
		pause_menu.queue_free()
		
	get_tree().paused = false
	
func settings_menu():
	if get_tree().get_root().find_child("SettingsMenuScreen"):
		return
		
	var settings_menu_screen_instance = SETTINS_MENU_SCREEN.instantiate()
	settings_menu_screen_instance.name = "SettingsMenuScreen"
	get_tree().get_root().add_child(settings_menu_screen_instance)

func pause_game():
	if get_tree().get_root().find_child("PauseMenuScreen"):
		return
		
	get_tree().paused = true
	var pause_menu_screen_instance = PAUSE_MENU_SCREEN.instantiate()
	pause_menu_screen_instance.name = "PauseMenuScreen"
	get_tree().get_root().add_child(pause_menu_screen_instance)
