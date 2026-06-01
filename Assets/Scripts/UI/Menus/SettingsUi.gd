extends Control
class_name SettingsUI

## Исправлены:
##   - elif OS.get_name() != "Web" → else (тавтологичное условие)
##   - Локали "EN" → "en", "RU" → "ru" (ISO 639-1, нижний регистр)
##   - GlobalContext.main_ui_instance → EventBus.pause_ui_open_requested

@export_group("Sound Sliders")
@export var master_slider: HSlider
@export var sfx_slider: HSlider
@export var music_slider: HSlider

@export_group("Mute Buttons")
@export var master_mute_button: TextureButton
@export var sfx_mute_button: TextureButton
@export var music_mute_button: TextureButton

@export_group("Text Numbers")
@export var master_volume_text: RichTextLabel
@export var sfx_volume_text: RichTextLabel
@export var music_volume_text: RichTextLabel

@export_group("Display Setting")
@export var display_tab_bar: TabBar
@export var current_window_mode_text: RichTextLabel
@export var current_resolution_mode_text: RichTextLabel
@export var array_window_mode: Array[String]
@export var array_resolution_mode: Array[String]

@export_group("Control Buttons")
@export var apply_button: TextureButton
@export var restore_defaults_button: TextureButton

var current_window_mode_index: int = 0
var current_resolution_mode_index: int = 0
# FIX: локаль в нижнем регистре
var current_language: String = "en"


func _ready() -> void:
	load_all_user_settings()
	if OS.get_name() == "Web":
		display_tab_bar.hide()


func button_hovered() -> void:
	if not GlobalAudio.button_hovered.playing:
		GlobalAudio.play_button_hover()


func apply_and_save_settings() -> void:
	if OS.get_name() == "Web":
		SettingManager.apply_settings(
			master_slider.value, master_mute_button.button_pressed,
			sfx_slider.value, sfx_mute_button.button_pressed,
			music_slider.value, music_mute_button.button_pressed,
			current_window_mode_index, current_resolution_mode_index,
			current_language
		)
	# FIX: elif OS.get_name() != "Web" — всегда true если первый if false → else
	else:
		SettingManager.save_settings(
			master_slider.value, master_mute_button.button_pressed,
			sfx_slider.value, sfx_mute_button.button_pressed,
			music_slider.value, music_mute_button.button_pressed,
			current_window_mode_index, current_resolution_mode_index,
			current_language
		)


func restore_defaults() -> void:
	restore_default_audio_value()
	restore_default_audio_mute()
	restore_default_display()
	apply_and_save_settings()


func restore_default_audio_value() -> void:
	master_slider.value = SettingManager.default_master_volume
	sfx_slider.value = SettingManager.default_sfx_volume
	music_slider.value = SettingManager.default_music_volume
	update_volume_text()


func restore_default_audio_mute() -> void:
	master_mute_button.button_pressed = SettingManager.default_is_master_volume_mute
	sfx_mute_button.button_pressed = SettingManager.default_is_sfx_volume_mute
	music_mute_button.button_pressed = SettingManager.default_is_music_volume_mute


func restore_default_display() -> void:
	set_window_text(SettingManager.default_window_mode)
	set_resolution_text(SettingManager.default_resolution_mode)


func load_all_user_settings() -> void:
	load_audio_settings()
	load_audio_mute_settings()
	load_display_settings()


func load_audio_settings() -> void:
	master_slider.value = SettingManager.get_master_volume()
	sfx_slider.value = SettingManager.get_sfx_volume()
	music_slider.value = SettingManager.get_music_volume()
	update_volume_text()


func load_audio_mute_settings() -> void:
	master_mute_button.button_pressed = SettingManager.get_master_volume_mute()
	sfx_mute_button.button_pressed = SettingManager.get_sfx_volume_mute()
	music_mute_button.button_pressed = SettingManager.get_music_volume_mute()


func update_volume_text() -> void:
	master_volume_text.text = str(round(master_slider.value)) + "%"
	sfx_volume_text.text = str(round(sfx_slider.value)) + "%"
	music_volume_text.text = str(round(music_slider.value)) + "%"


func load_display_settings() -> void:
	set_window_text(SettingManager.get_window_mode())
	set_resolution_text(SettingManager.get_resolution())


func on_value_text_update(_value: float) -> void:
	update_volume_text()


func set_window_text(index: int) -> void:
	current_window_mode_text.text = array_window_mode[index]
	current_window_mode_index = index


func set_resolution_text(index: int) -> void:
	current_resolution_mode_text.text = array_resolution_mode[index]
	current_resolution_mode_index = index


func on_decrease_window_mode() -> void:
	if current_window_mode_index > 0:
		current_window_mode_index -= 1
		set_window_text(current_window_mode_index)


func on_increase_window_mode() -> void:
	if current_window_mode_index < array_window_mode.size() - 1:
		current_window_mode_index += 1
		set_window_text(current_window_mode_index)


func on_decrease_resolution_mode() -> void:
	if current_resolution_mode_index > 0:
		current_resolution_mode_index -= 1
		set_resolution_text(current_resolution_mode_index)


func on_increase_resolution_mode() -> void:
	if current_resolution_mode_index < array_resolution_mode.size() - 1:
		current_resolution_mode_index += 1
		set_resolution_text(current_resolution_mode_index)


func _on_close_button_pressed() -> void:
	# FIX: убран GlobalContext.main_ui_instance → EventBus
	EventBus.pause_ui_open_requested.emit()
	queue_free()


func _on_en_language_pressed() -> void:
	# FIX: "EN" → "en"
	SettingManager.apply_language("en")
	current_language = "en"


func _on_ru_language_pressed() -> void:
	# FIX: "RU" → "ru"
	SettingManager.apply_language("ru")
	current_language = "ru"
