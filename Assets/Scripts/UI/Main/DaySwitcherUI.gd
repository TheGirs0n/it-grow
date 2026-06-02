extends Control
class_name DaySwitcherUI

## FIX: GlobalContext убран — пропущен при предыдущем рефакторинге
## close_day_switcher() теперь эмитит EventBus.day_switcher_close_requested
## GameManager уже подписан на этот сигнал

@export_group("Day Texts")
@export var current_day_text: RichTextLabel
@export var next_day_text: RichTextLabel

var tween: Tween


func _ready() -> void:
	modulate.a = 0.0
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 3.0)


func prepare_text(current_day: int) -> void:
	current_day_text.text = str(current_day - 1)
	next_day_text.text = str(current_day)


func close_day_switcher() -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 3.0)
	tween.tween_callback(queue_free)

	# FIX: было GlobalContext.game_manager_instance.new_day_parameters()
	# и GlobalContext.game_manager_instance.day_timer.paused = false
	# GameManager._on_day_switcher_close() обрабатывает оба вызова
	EventBus.day_switcher_close_requested.emit()
