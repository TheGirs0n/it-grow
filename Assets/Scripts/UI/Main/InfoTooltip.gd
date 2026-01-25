extends Control
class_name InfoTooltip

@export var info_text : RichTextLabel
@export var tooltip_timer : Timer

var simple_tween : Tween

func change_text(new_text : String):
	info_text.text = new_text
	
func show_tooltip():
	simple_tween = get_tree().create_tween()
	simple_tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tooltip_timer.start()
	
func hide_tooltip():
	simple_tween = get_tree().create_tween()
	simple_tween.tween_property(self, "modulate:a", 0.0, 0.3)
