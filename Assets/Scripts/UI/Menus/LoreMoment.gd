extends Control

@export var main_scene : PackedScene
@export var animation_player : AnimationPlayer

var is_text_full_appeared : bool = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				print(is_text_full_appeared)
				try_close_lore_entrance()


func try_close_lore_entrance() -> void:
	if is_text_full_appeared == false:
		var length = animation_player.current_animation_length
		animation_player.advance(length)
	else:
		var scene = main_scene.instantiate() as GameManager
		get_tree().root.add_child(scene)
		self.queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "text_appear":
		is_text_full_appeared = true
