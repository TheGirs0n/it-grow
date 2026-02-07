extends Control
class_name FindBoxItem

@export var find_box_type : GlobalEnums.PLANT_FIND_TYPE
@export var texture : TextureRect
@export var clicked_item_icon : CompressedTexture2D
@export var normal_item_icon : CompressedTexture2D
@export var mouse_icon : CompressedTexture2D

signal item_picked(item : FindBoxItem)

var mouse_entered_offset : Vector2 = Vector2(0, -15)
var original_position : Vector2

var tween : Tween

func _ready() -> void:
	original_position = position

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				item_picked.emit(self)
				change_mouse_on_item()

func _mouse_enter():
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", original_position + mouse_entered_offset, 0.2)

func _mouse_exit():
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", original_position, 0.2)

func change_mouse_on_item():
	texture.texture = clicked_item_icon
	Input.set_custom_mouse_cursor(mouse_icon)
	
func set_default_mouse_on_item():
	texture.texture = normal_item_icon
	Input.set_custom_mouse_cursor(null)
