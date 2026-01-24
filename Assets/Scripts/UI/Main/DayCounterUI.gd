extends Control
class_name DayCounterUI

@export_group("Texts")
@export var day_counter_text : RichTextLabel
@export var day_counter_number : RichTextLabel

func set_day_counter_text(current_day : int):
	day_counter_text.text = "ДЕНЬ - " + str(current_day)
	
func set_day_counter_number(current_number : int):
	day_counter_number.text = "ОСТАВШЕЕСЯ ВРЕМЯ ДНЯ - " + str(current_number)
