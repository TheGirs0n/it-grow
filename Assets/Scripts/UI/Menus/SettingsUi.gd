extends Control
class_name SettingsUI

@export_group("Sound Sliders")
@export var master_slider : HSlider
@export var sfx_slider : HSlider
@export var music_slider : HSlider

@export_group("Mute Buttons")
@export var master_mute_button : TextureButton
@export var sfx_mute_button : TextureButton
@export var music_mute_button : TextureButton

@export_group("Text Numbers")
@export var master_volume_text : RichTextLabel
@export var sfx_volume_text : RichTextLabel
@export var music_volume_text : RichTextLabel

@export_group("Display Setting")
@export var current_window_mode_text : RichTextLabel
@export var current_resolution_mode_text : RichTextLabel
@export var array_window_mode : Array[String]
@export var array_resolution_mode : Array[String]

@export_group("Language Setting")
@export var language_toggle_button : CheckButton

@export_group("Control Buttons")
@export var apply_button : TextureButton
@export var restore_defaults_button : TextureButton

var current_window_mode_index : int = 0
var current_resolution_mode_index : int = 0
var current_language : String = "EN"


func _ready() -> void:
	load_all_user_settings()
	

func apply_and_save_settings() -> void:
	SettingManager.save_settings(
		master_slider.value, master_mute_button.button_pressed,
		sfx_slider.value, sfx_mute_button.button_pressed,
		music_slider.value, music_mute_button.button_pressed,
		current_window_mode_index, current_resolution_mode_index,
		current_language)


func restore_defaults() -> void:
	restore_default_audio_value()
	restore_default_audio_mute()
	restore_default_display()
	restore_default_language()
	
	apply_and_save_settings()


func restore_default_audio_value():
	var default_master_volume : float = SettingManager.default_master_volume
	var default_sfx_volume : float = SettingManager.default_sfx_volume
	var default_music_volume : float = SettingManager.default_music_volume
	
	master_slider.value = default_master_volume
	sfx_slider.value = default_sfx_volume
	music_slider.value = default_music_volume
	
	update_volume_text()
	
	
func restore_default_audio_mute():
	var default_is_master_volume_mute : bool = SettingManager.default_is_master_volume_mute
	var default_is_sfx_volume_mute : bool = SettingManager.default_is_sfx_volume_mute
	var default_is_music_volume_mute : bool = SettingManager.default_is_music_volume_mute
	
	master_mute_button.button_pressed = default_is_master_volume_mute
	sfx_mute_button.button_pressed = default_is_sfx_volume_mute
	music_mute_button.button_pressed = default_is_music_volume_mute


func restore_default_display():
	var default_window_mode : int = SettingManager.default_window_mode
	var default_resolution_mode : int = SettingManager.default_resolution_mode
	
	set_window_text(default_window_mode)
	set_resolution_text(default_resolution_mode)
	
	
func restore_default_language():
	var default_language : String = SettingManager.default_language
	language_toggle_button.button_pressed = false
	
	
func load_all_user_settings():
	load_audio_settings()
	load_audio_mute_settings()
	load_display_settings()
	load_language_settings()
	
func load_audio_settings():
	master_slider.value = SettingManager.get_master_volume()
	sfx_slider.value = SettingManager.get_sfx_volume()
	music_slider.value = SettingManager.get_music_volume()
	update_volume_text()

func load_audio_mute_settings():
	master_mute_button.button_pressed = SettingManager.get_master_volume_mute()
	sfx_mute_button.button_pressed = SettingManager.get_sfx_volume_mute()
	music_mute_button.button_pressed = SettingManager.get_music_volume_mute()


func update_volume_text():
	master_volume_text.text = str(round(master_slider.value)) + "%"
	sfx_volume_text.text = str(round(sfx_slider.value)) + "%"
	music_volume_text.text = str(round(music_slider.value)) + "%"


func load_display_settings():
	var window_mode : int = SettingManager.get_window_mode()
	var resolution : int = SettingManager.get_resolution()

	set_window_text(window_mode)
	set_resolution_text(resolution)


func load_language_settings():
	var language = SettingManager.get_language()
	if language == "EN":
		language_toggle_button.button_pressed = false
	else:
		language_toggle_button.button_pressed = true


func on_value_text_update(_value: float) -> void:
	update_volume_text()


func set_window_text(index : int):
	current_window_mode_text.text = array_window_mode[index]
	current_window_mode_index = index


func set_resolution_text(index : int):
	current_resolution_mode_text.text = array_resolution_mode[index]
	current_resolution_mode_index = index


func on_decrease_window_mode() -> void:
	if current_window_mode_index > 0:
		current_window_mode_index -= 1
		set_window_text(current_window_mode_index)


func on_increase_window_mode() -> void:
	if current_window_mode_index < 1:
		current_window_mode_index += 1
		set_window_text(current_window_mode_index)


func on_decrease_resolution_mode() -> void:
	if current_resolution_mode_index > 0:
		current_resolution_mode_index -= 1
		set_resolution_text(current_resolution_mode_index)


func on_increase_resolution_mode() -> void:
	if current_resolution_mode_index < 4:
		current_resolution_mode_index += 1
		set_resolution_text(current_resolution_mode_index)


func _on_close_button_pressed() -> void:
	if GlobalContext.main_ui_instance != null:
		GlobalContext.main_ui_instance.open_pause()
	queue_free()
