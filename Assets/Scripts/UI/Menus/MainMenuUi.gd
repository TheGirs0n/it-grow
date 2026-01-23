extends Control
class_name MainMenuUI

@export_group("Packed Scenes")
@export var game_start : PackedScene
@export var settings_scene : PackedScene

func _on_start_game_pressed() -> void:
	pass

func _on_settings_pressed() -> void:
	pass

func _on_exit_pressed() -> void:
	get_tree().quit()
