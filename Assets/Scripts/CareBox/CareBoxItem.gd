extends Node
class_name CareBoxItem

@export var plant_care_type : GlobalEnums.PLANT_CARE_TYPE
@export var mini_care_box_item_icon : CompressedTexture2D

static var current_care_box_item : CareBoxItem
var is_selected : bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			current_care_box_item = self
			change_mouse_on_item()


func change_mouse_on_item():
	is_selected = true
	Input.set_custom_mouse_cursor(mini_care_box_item_icon)

func set_default_mouse_on_item():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func interact_with_plant():
	
	set_default_mouse_on_item()
	# сделать что-то
