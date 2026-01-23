extends Control
class_name CareBoxItem

@export var plant_care_type : GlobalEnums.PLANT_CARE_TYPE
@export var mini_care_box_item_icon : CompressedTexture2D

signal item_picked(item : CareBoxItem)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				item_picked.emit(self)
				change_mouse_on_item()

func change_mouse_on_item():
	Input.set_custom_mouse_cursor(mini_care_box_item_icon)
	print(name)

func set_default_mouse_on_item():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func interact_with_plant():
	set_default_mouse_on_item()
	
func mouse_entered():
	print(name)
