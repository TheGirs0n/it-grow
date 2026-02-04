extends Area2D
class_name CareBoxItem

@export var plant_care_type : GlobalEnums.PLANT_CARE_TYPE
@export var sprite : Sprite2D
@export var clicked_item_icon : CompressedTexture2D
@export var normal_item_icon : CompressedTexture2D
@export var mouse_icon : CompressedTexture2D

var mouse_entered_offset : Vector2 = Vector2(0, -15)
var original_position : Vector2

var tween : Tween

signal item_picked(item : CareBoxItem)

func _ready() -> void:
	original_position = position

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				item_picked.emit(self)
				print("ITEM PICKED: " + self.name)
				change_mouse_on_item()

func _mouse_enter():
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position + mouse_entered_offset, 0.2)

func _mouse_exit():
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", original_position, 0.2)

func change_mouse_on_item():
	sprite.texture = clicked_item_icon
	Input.set_custom_mouse_cursor(mouse_icon)

func set_default_mouse_on_item():
	sprite.texture = normal_item_icon
	Input.set_custom_mouse_cursor(null)
