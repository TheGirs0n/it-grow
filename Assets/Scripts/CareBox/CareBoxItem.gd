extends Area2D
class_name CareBoxItem

@export var plant_care_type : GlobalEnums.PLANT_CARE_TYPE
@export var sprite : Sprite2D
@export var clicked_item_icon : CompressedTexture2D
@export var normal_item_icon : CompressedTexture2D
@export var mouse_icon : CompressedTexture2D

signal item_picked(item : CareBoxItem)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				item_picked.emit(self)
				print("ITEM PICKED: " + self.name)
				change_mouse_on_item()

func change_mouse_on_item():
	sprite.texture = clicked_item_icon
	Input.set_custom_mouse_cursor(mouse_icon)

func set_default_mouse_on_item():
	sprite.texture = normal_item_icon
	Input.set_custom_mouse_cursor(null)
