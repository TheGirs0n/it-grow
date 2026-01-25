extends Control
class_name DaySwitcherUI

@export_group("Day Texts")
@export var current_day_text : RichTextLabel
@export var next_day_text : RichTextLabel

var tween : Tween

func prepare_text(current_day : int):
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 3)
	
	current_day_text.text = str(current_day - 1)
	next_day_text.text = str(current_day)
	GlobalContext.game_manager_instance.new_day_parameters()
	

func close_day_switcher():
	queue_free()
