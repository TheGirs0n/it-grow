extends Node
class_name FindBoxItem

@export var find_box_type : GlobalEnums.PLANT_FIND_TYPE
@export var texture : TextureRect
@export var clicked_item_icon : CompressedTexture2D
@export var normal_item_icon : CompressedTexture2D
@export var mouse_icon : CompressedTexture2D

signal item_picked(item : FindBoxItem)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				item_picked.emit(self)
				print("ITEM PICKED: " + self.name)
				change_mouse_on_item()

func change_mouse_on_item():
	texture.texture = clicked_item_icon
	Input.set_custom_mouse_cursor(mouse_icon)
	
func set_default_mouse_on_item():
	texture.texture = normal_item_icon
	Input.set_custom_mouse_cursor(null)
