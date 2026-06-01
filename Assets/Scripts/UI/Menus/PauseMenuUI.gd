extends Control
class_name PauseMenuUI

## Убран GlobalContext → EventBus для продолжения игры и выхода

@export var setting_scene: PackedScene
@export var main_menu_scene: PackedScene


func button_hovered() -> void:
	if not GlobalAudio.button_hovered.playing:
		GlobalAudio.play_button_hover()


func continue_button_game() -> void:
	# FIX: убраны GlobalContext.main_ui_instance и GlobalContext.game_manager_instance
	EventBus.game_continued.emit()


func settings_button_pressed() -> void:
	var scene := setting_scene.instantiate() as SettingsUI
	scene.load_all_user_settings()
	# Добавляем в MainUI — PauseMenuUI является дочерним, get_parent() → MainUI
	get_parent().add_child(scene)
	get_parent().settings_scene_open()


func exit_button_pressed() -> void:
	var main_menu := main_menu_scene.instantiate() as MainMenuUI
	get_tree().root.add_child(main_menu)
	# FIX: убран GlobalContext.game_manager_instance → EventBus
	EventBus.game_manager_free_requested.emit()
