extends Control
class_name SettingsUI

@export_group("Sound Sliders")
@export var master_slider : HSlider
@export var sfx_slider : HSlider
@export var music_slider : HSlider

@export_group("Text Numbers")
@export var master_volume_text : RichTextLabel
@export var sfx_volume_text : RichTextLabel
@export var music_volume_text : RichTextLabel

@export_group("Display Setting")
@export var current_window_mode_text : RichTextLabel
@export var current_resolution_mode_text : RichTextLabel
@export var array_window_mode : Array[String]
@export var array_resolution_mode : Array[String]

var current_window_mode_index : int = 0
var current_resolution_mode_index : int = 0

@export_group("Control Buttons")
@export var apply_button : Button
@export var restore_defaults_button : Button

func _ready() -> void:
	load_all_user_settings()
	

func apply_and_save_settings() -> void:
	SettingManager.save_settings(master_slider.value, 
	sfx_slider.value, 
	music_slider.value,
	current_window_mode_index,
	current_resolution_mode_index)


func restore_defaults() -> void:
	var default_master_volume : float = 50.0
	var default_sfx_volume : float = 50.0
	var default_music_volume : float = 50.0
	
	var default_window_mode : int = 1
	var default_resolution : int = 0
	
	master_slider.value = default_master_volume
	sfx_slider.value = default_sfx_volume
	music_slider.value = default_music_volume
	
	update_volume_text()
	
	set_window_text(default_window_mode)
	set_resolution_text(default_resolution)
	
	apply_and_save_settings()

func load_all_user_settings():
	load_audio_settings()
	update_volume_text()
	load_display_settings()
	
func load_audio_settings():
	master_slider.value = SettingManager.get_master_volume()
	sfx_slider.value = SettingManager.get_sfx_volume()
	music_slider.value = SettingManager.get_music_volume()

func update_volume_text():
	master_volume_text.text = str(round(master_slider.value))
	sfx_volume_text.text = str(round(sfx_slider.value))
	music_volume_text.text = str(round(music_slider.value))


func load_display_settings():
	var window_mode : int = SettingManager.get_window_mode()
	var resolution : int = SettingManager.get_resolution()

	set_window_text(window_mode)
	set_resolution_text(resolution)

func on_value_text_update(value: float) -> void:
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
	if current_resolution_mode_index < 3:
		current_resolution_mode_index += 1
		set_resolution_text(current_resolution_mode_index)
