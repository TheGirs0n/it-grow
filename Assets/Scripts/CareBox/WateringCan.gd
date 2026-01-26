extends CareBoxItem
class_name WateringCan

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				item_picked.emit(self)
				GlobalAudio.play_watering_can_take()
				change_mouse_on_item()
