extends Control
class_name MainMenuUI

@export_group("Packed Scenes")
@export var game_start : PackedScene
@export var settings_scene : PackedScene

func _on_start_game_pressed() -> void:
	pass

func _on_settings_pressed() -> void:
	var scene = settings_scene.instantiate() as SettingsUI
	add_child(scene)

func _on_exit_pressed() -> void:
	get_tree().quit()
