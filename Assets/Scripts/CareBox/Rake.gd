extends CareBoxItem
class_name Rake

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				item_picked.emit(self)
				GlobalAudio.play_rake_take()
				change_mouse_on_item()
