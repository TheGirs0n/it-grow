extends TextureRect


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				if GlobalContext.main_ui_instance.find_box_ui.current_find_box_item != null:
					GlobalContext.main_ui_instance.find_box_ui.clear_current_find_box_item()
	
				if GlobalContext.main_ui_instance.care_box_ui.current_care_box_item != null:
					GlobalContext.main_ui_instance.care_box_ui.clear_current_care_box_item()
