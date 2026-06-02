extends Control
class_name DayCounterUI

@export_group("Texts")
@export var day_counter_text: RichTextLabel
@export var day_counter_number: RichTextLabel


func set_day_counter_text(current_day: int) -> void:
	day_counter_text.text = TranslationServer.translate("UI_DAY_TIMER_UPPER_TEXT") + str(current_day)


func set_day_counter_number(current_number: float) -> void:
	# FIX: параметр был int, но EventBus.day_timer_tick эмитит float (time_left таймера)
	# ceili() округляем вверх чтобы таймер не показывал 0 пока идёт последняя секунда
	day_counter_number.text = TranslationServer.translate("UI_DAY_TIMER_BOTTOM_TEXT") + str(ceili(current_number))
