extends Node
class_name FindBoxItem

@export var find_box_type : GlobalEnums.PLANT_FIND_TYPE
@export var find_box_item_icon : CompressedTexture2D

signal item_picked(item : FindBoxItem)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				item_picked.emit(self)
				print("ITEM PICKED: " + self.name)
				change_mouse_on_item()

func change_mouse_on_item():
	Input.set_custom_mouse_cursor(find_box_item_icon)

func set_default_mouse_on_item():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
