extends CanvasLayer
class_name TutorialController

## Интерактивное обучение (Вариант B).
##
## Накладывается поверх обычной игры и ведёт игрока по реальному первому цветку:
##   1. вступление,
##   2. осмотр цветка инструментом поиска (ждём EventBus.find_box_center_show),
##   3. подсказка про книгу ухода,
##   4. динамический уход по шагам (ждём EventBus.plant_care_stage_completed),
##   5. финал → отдаём управление обычной игре.
##
## Контроллер НЕ трогает игровую логику — только слушает существующие сигналы
## и ограничивает ввод уже имеющимися механизмами (input_pickable). Визуал строится
## в коде, чтобы не плодить хрупкие .tscn; позиции/отступы можно донастроить в редакторе.

# Ассеты загружаем через load() с защитой от null — пути с кириллицей не должны ронять сцену
const BUBBLE_TEX_PATH := "res://Assets/Sprites/UI/Tooltip/подложка под текст.png"
const ARROW_TEX_PATH := "res://Assets/Sprites/UI/Menus/Pause/стрелочка.png"
const FONT_PATH := "res://Assets/Fonts/ofont.ru_Daneehand.ttf"

const ARROW_OFFSET := Vector2(-24, -96)

signal _next_requested()

var _main_ui: MainUI
var _plant: PlantTemplate

var _dim: ColorRect
var _panel: NinePatchRect
var _label: RichTextLabel
var _next_button: Button
var _skip_button: Button
var _arrow: TextureRect
var _arrow_tween: Tween

var _finished: bool = false


func begin(main_ui: MainUI) -> void:
	_main_ui = main_ui
	_plant = main_ui.plant_spawn_location.get_current_plant()

	# Без растения вести обучение не по чему — мягко выходим и не блокируем игру
	if _plant == null:
		push_warning("TutorialController: растение не найдено, обучение пропущено")
		EventBus.tutorial_finished.emit()
		queue_free()
		return

	_build_ui()
	_run()


# --- Построение оверлея ---

func _build_ui() -> void:
	layer = 128
	# Оверлей живёт поверх обычной игры, которая не на паузе
	process_mode = Node.PROCESS_MODE_ALWAYS

	var screen := get_viewport().get_visible_rect().size

	_dim = ColorRect.new()
	_dim.color = Color(0, 0, 0, 0.35)
	_dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	# IGNORE — клики проходят сквозь затемнение к инструментам/цветку
	_dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_dim)

	_arrow = TextureRect.new()
	var arrow_tex: Texture2D = load(ARROW_TEX_PATH)
	if arrow_tex != null:
		_arrow.texture = arrow_tex
	_arrow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_arrow.visible = false
	add_child(_arrow)

	# Панель-подсказка — вверху по центру, чтобы не перекрывать ящики внизу
	_panel = NinePatchRect.new()
	var bubble_tex: Texture2D = load(BUBBLE_TEX_PATH)
	if bubble_tex != null:
		_panel.texture = bubble_tex
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var panel_size := Vector2(820, 170)
	_panel.position = Vector2((screen.x - panel_size.x) * 0.5, 28)
	_panel.size = panel_size
	add_child(_panel)

	var font: Font = load(FONT_PATH)

	_label = RichTextLabel.new()
	_label.bbcode_enabled = true
	_label.fit_content = true
	_label.scroll_active = false
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.position = Vector2(36, 24)
	_label.size = Vector2(panel_size.x - 72, panel_size.y - 78)
	if font != null:
		_label.add_theme_font_override("normal_font", font)
	_label.add_theme_font_size_override("normal_font_size", 30)
	_panel.add_child(_label)

	_next_button = Button.new()
	_next_button.text = "ДАЛЕЕ ▶"
	_next_button.size = Vector2(180, 48)
	_next_button.position = Vector2(panel_size.x - 180 - 36, panel_size.y - 48 - 18)
	if font != null:
		_next_button.add_theme_font_override("font", font)
	_next_button.pressed.connect(func() -> void: _next_requested.emit())
	_panel.add_child(_next_button)

	_skip_button = Button.new()
	_skip_button.text = "Пропустить обучение"
	_skip_button.size = Vector2(220, 40)
	_skip_button.position = Vector2(screen.x - 220 - 24, screen.y - 40 - 24)
	if font != null:
		_skip_button.add_theme_font_override("font", font)
	_skip_button.pressed.connect(_on_skip_pressed)
	add_child(_skip_button)


# --- Сценарий обучения ---

func _run() -> void:
	await _narrative(_t("TUTORIAL_INTRO",
		"Привет! Это твой первый цветок. Давай вместе научимся за ним ухаживать."))

	# Шаг осмотра: оставляем доступными только инструменты поиска
	_main_ui.care_box_ui.disable_input_for_items()
	await _action(
		_t("TUTORIAL_INVESTIGATE",
			"Сначала изучи цветок. Потяни за ящик инструментов и осмотри цветок (например, лупой)."),
		_main_ui.find_box_ui.get_handle_screen_position(),
		EventBus.find_box_center_show)
	if _finished:
		return

	await _narrative(_t("TUTORIAL_BOOK_TIP",
		"Инструменты подсказывают свойства цветка. Сверяй их с книгой ухода, чтобы понять, что ему нужно."))

	# Закрываем ящик и запираем его, чтобы игрок не отключил уход, открыв ящик
	_main_ui.find_box_ui.close_box()
	_main_ui.find_box_ui.set_handle_enabled(false)

	# Динамический уход: ведём по реальной последовательности этого цветка
	var care_sequence: Array = _plant.plant_care_stages
	for i in care_sequence.size():
		var care_type: int = care_sequence[i]
		_main_ui.care_box_ui.set_only_enabled(care_type)
		_show_action(_care_text(care_type), _main_ui.care_box_ui.get_item_screen_position(care_type))
		await EventBus.plant_care_stage_completed
		if _finished:
			return

	_main_ui.care_box_ui.enable_input_for_items()
	_main_ui.find_box_ui.set_handle_enabled(true)

	await _narrative(_t("TUTORIAL_OUTRO",
		"Отлично получается! Дальше справишься сам — доведи цветок до конца, пока идёт день."))

	_finish()


# --- Шаги ---

## Повествовательный шаг: текст + кнопка «Далее»
func _narrative(text: String) -> void:
	_set_text(text)
	_hide_arrow()
	_next_button.show()
	await _next_requested


## Шаг-действие: текст + стрелка на цель, ждём конкретный сигнал
func _action(text: String, target_screen_pos: Vector2, signal_to_wait: Signal) -> void:
	_show_action(text, target_screen_pos)
	await signal_to_wait


func _show_action(text: String, target_screen_pos: Vector2) -> void:
	_set_text(text)
	_next_button.hide()
	_point_arrow(target_screen_pos)


func _set_text(text: String) -> void:
	_label.text = text


func _point_arrow(target_screen_pos: Vector2) -> void:
	if _arrow.texture == null:
		return
	_arrow.show()
	_arrow.global_position = target_screen_pos + ARROW_OFFSET

	if _arrow_tween:
		_arrow_tween.kill()
	# Лёгкое «подпрыгивание», чтобы стрелка привлекала внимание
	_arrow_tween = create_tween().set_loops()
	_arrow_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var base := _arrow.global_position
	_arrow_tween.tween_property(_arrow, "global_position", base + Vector2(0, 14), 0.5)
	_arrow_tween.tween_property(_arrow, "global_position", base, 0.5)


func _hide_arrow() -> void:
	if _arrow_tween:
		_arrow_tween.kill()
	_arrow.hide()


# --- Завершение ---

func _on_skip_pressed() -> void:
	# Восстанавливаем нормальное состояние ввода на случай пропуска посреди шага
	_main_ui.find_box_ui.close_box()
	_main_ui.find_box_ui.set_handle_enabled(true)
	_main_ui.care_box_ui.enable_input_for_items()
	_finish()


func _finish() -> void:
	if _finished:
		return
	_finished = true

	SettingManager.set_tutorial_completed(true)
	EventBus.tutorial_finished.emit()
	queue_free()


# --- Тексты ---

## Перевод с фолбэком: если ключ ещё не в .translation, показываем читаемый русский текст.
## Когда CSV переимпортируют в редакторе, автоматически подхватятся локализованные строки.
func _t(key: String, fallback: String) -> String:
	var translated := tr(key)
	return fallback if translated == key else translated


func _care_text(care_type: int) -> String:
	match care_type:
		GlobalEnums.PLANT_CARE_TYPE.WATERING_CAN:
			return _t("TUTORIAL_CARE_WATERING", "Возьми лейку и полей цветок — затем нажми на него.")
		GlobalEnums.PLANT_CARE_TYPE.RAKE:
			return _t("TUTORIAL_CARE_RAKE", "Возьми грабли и взрыхли землю — затем нажми на цветок.")
		GlobalEnums.PLANT_CARE_TYPE.FERTILIZER:
			return _t("TUTORIAL_CARE_FERTILIZER", "Возьми удобрение и подкорми цветок — затем нажми на него.")
	return ""
