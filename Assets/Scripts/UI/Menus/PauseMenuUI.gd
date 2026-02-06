extends Control
class_name PauseMenuUI

@export var setting_scene : PackedScene
@export var main_menu_scene : PackedScene

func button_hovered():
	if !GlobalAudio.button_hovered.playing:
		GlobalAudio.play_button_hover()

func continue_button_game() -> void:
	GlobalContext.main_ui_instance.hide_pause()
	GlobalContext.game_manager_instance.continue_game()


func settings_button_pressed() -> void:
	var scene = setting_scene.instantiate() as SettingsUI
	scene.load_all_user_settings()
	GlobalContext.main_ui_instance.add_child(scene)
	GlobalContext.main_ui_instance.settings_scene_open()


func exit_button_pressed() -> void:
	var main_menu_scene_new = main_menu_scene.instantiate() as MainMenuUI
	get_tree().root.add_child(main_menu_scene_new)
	GlobalContext.game_manager_instance.queue_free()
	print(GlobalContext.game_manager_instance)
