extends Control
class_name VictoryScreen

## Убран GlobalContext.game_manager_instance → EventBus

@export var main_menu_scene: PackedScene


func _ready() -> void:
	GlobalAudio.play_win()


func _on_button_pressed() -> void:
	EventBus.game_manager_free_requested.emit()
	var scene := main_menu_scene.instantiate() as MainMenuUI
	get_tree().root.add_child(scene)
