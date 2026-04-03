extends Control
class_name MainMenuUI

@export_group("Packed Scenes")
@export var settings_scene : PackedScene

@export_group("Buttons")
@export var exit_button : TextureButton

func _ready() -> void:
	if OS.get_name() == "Web":
		exit_button.hide()


func button_hovered():
	if !GlobalAudio.button_hovered.playing:
		GlobalAudio.play_button_hover()


func _on_start_game_pressed() -> void:
	if GlobalContext.game_manager_instance != null:
		GlobalContext.game_manager_instance.queue_free()
	
	var start_game = ResourceLoader.load("res://Assets/Scenes/UI/Tutorial.tscn").instantiate()
	get_tree().root.add_child(start_game)
	self.queue_free()


func _on_settings_pressed() -> void:
	var scene = settings_scene.instantiate() as SettingsUI
	add_child(scene)


func _on_exit_pressed() -> void:
	get_tree().quit()
