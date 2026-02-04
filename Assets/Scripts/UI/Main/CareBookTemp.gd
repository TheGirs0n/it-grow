extends Button

var mouse_entered_offset : Vector2 = Vector2(0, -15)
var original_position : Vector2

var tween : Tween

func _ready() -> void:
	original_position = position

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
