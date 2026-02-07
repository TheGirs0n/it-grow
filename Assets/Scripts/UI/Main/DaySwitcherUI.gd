extends Control
class_name DaySwitcherUI

@export_group("Day Texts")
@export var current_day_text : RichTextLabel
@export var next_day_text : RichTextLabel

var tween : Tween

func _ready() -> void:
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 3)

func prepare_text(current_day : int):
	current_day_text.text = str(current_day - 1)
	next_day_text.text = str(current_day)
	

func close_day_switcher():
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 3)
	tween.tween_callback(queue_free)
	GlobalContext.game_manager_instance.new_day_parameters()
	GlobalContext.game_manager_instance.day_timer.paused = false
