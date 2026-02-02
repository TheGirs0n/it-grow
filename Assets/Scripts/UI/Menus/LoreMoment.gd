extends Control

@export var main_scene : PackedScene



func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				var scene = main_scene.instantiate() as GameManager
				get_tree().root.add_child(scene)
				self.queue_free()


func _on_timer_timeout() -> void:
	var scene = main_scene.instantiate() as GameManager
	get_tree().root.add_child(scene)
	self.queue_free()
