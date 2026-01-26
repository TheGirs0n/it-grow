extends Control
class_name VictoryScreen

@export var main_menu_scene : PackedScene

func _ready() -> void:
	GlobalAudio.play_win()

func _on_button_pressed() -> void:
	GlobalContext.game_manager_instance.queue_free()
	var scene = main_menu_scene.instantiate() as MainMenuUI
	get_tree().root.add_child(scene)
