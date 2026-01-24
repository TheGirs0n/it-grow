extends Control
class_name InfoTooltip

@export var info_text : RichTextLabel

var simple_tween : Tween

func change_text(new_text : String):
	info_text.text = new_text
	
func show_tooltip():
	if simple_tween:
		simple_tween.kill()
		
	simple_tween = create_tween()
	simple_tween.tween_property(self, "modulate:a", 1.0, 0.3)
	
func hide_tooltip():
	if simple_tween:
		simple_tween.kill()
		
	simple_tween = create_tween()
	simple_tween.tween_property(self, "modulate:a", 0.0, 0.3)
