extends Node

var config_file : ConfigFile
var config_path : String = "user://settings.cfg"

var default_master_volume : float = 50.0
var default_sfx_volume : float = 50.0
var default_music_volume : float = 50.0

var default_is_master_volume_mute : bool = false
var default_is_sfx_volume_mute : bool = false
var default_is_music_volume_mute : bool = false

var default_window_mode : int = 1
var default_resolution_mode : int = 0

var default_language : String = "EN"

func _enter_tree() -> void:
	load_setting_at_startup()


func load_setting_at_startup():
	config_file = ConfigFile.new()
	var is_have_config = config_file.load(config_path)
	
	if is_have_config != OK:
		apply_default_setting()
		
	apply_setting_from_config()
	
	
func apply_setting_from_config():
	var master_volume : float = config_file.get_value("audio", "master_volume", default_master_volume)
	var sfx_volume : float = config_file.get_value("audio", "sfx_volume", default_sfx_volume)
	var music_volume : float = config_file.get_value("audio", "music_volume", default_music_volume)
	
	var is_master_volume_mute : bool = config_file.get_value("audio", "mute_master_volume", default_is_master_volume_mute)
	var is_sfx_volume_mute : bool = config_file.get_value("audio", "mute_sfx_volume", default_is_sfx_volume_mute)
	var is_music_volume_mute : bool = config_file.get_value("audio", "mute_music_volume", default_is_music_volume_mute)
	
	var window_mode : int = config_file.get_value("video", "window_mode", default_window_mode)
	var resolution_mode : int = config_file.get_value("video", "resolution", default_resolution_mode)
	
	var language : String = config_file.get_value("language", "language", default_language)
	
	apply_settings(master_volume, is_master_volume_mute,
					sfx_volume, is_sfx_volume_mute,
					music_volume, is_music_volume_mute,
					window_mode, resolution_mode, language)
	
func apply_default_setting():
	apply_settings(default_master_volume, default_is_master_volume_mute, 
					default_sfx_volume, default_is_sfx_volume_mute,
					default_music_volume, default_is_music_volume_mute,
					default_window_mode, default_resolution_mode, default_language)
	
	
func apply_settings(master_volume: float, is_master_volume_mute: bool, 
					sfx_volume: float, is_sfx_volume_mute: bool, 
					music_volume: float, is_music_volume_mute: bool,
					window_mode: int, resolution_mode: int, language : String):
						
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume / 100.0))
	AudioServer.set_bus_volume_db(1, linear_to_db(sfx_volume / 100.0))
	AudioServer.set_bus_volume_db(2, linear_to_db(music_volume / 100.0))
	
	AudioServer.set_bus_mute(0, is_master_volume_mute)
	AudioServer.set_bus_mute(1, is_sfx_volume_mute)
	AudioServer.set_bus_mute(2, is_music_volume_mute)
	
	apply_window_mode(window_mode)
	apply_resolution(resolution_mode, window_mode)
	apply_language(language)
	
	
func apply_window_mode(mode_index : int):
	match mode_index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			center_window()
		
		
func apply_resolution(index : int, window_mode : int):
	if window_mode != 1:
		return
	
	var resolutions: Array[Vector2i] = [
		Vector2i(1280, 720),
		Vector2i(1366, 768),
		Vector2i(1600, 900),
		Vector2i(1920, 1080),
		Vector2i(2560, 1440)
	]
	
	if index < 0 or index >= resolutions.size():
		return
	
	DisplayServer.window_set_size(resolutions[index])
	center_window()
	
	
func apply_language(new_language : String):
	TranslationServer.set_locale(new_language)
	
	
func center_window() -> void:
	var screen: Vector2i = DisplayServer.screen_get_size()
	var win: Vector2i = DisplayServer.window_get_size()
	
	var center: Vector2i = Vector2i(
		(screen.x - win.x) / 2,
		(screen.y - win.y) / 2
	)
	
	DisplayServer.window_set_position(center)
	
func get_master_volume() -> float:
	return config_file.get_value("audio", "master_volume", default_master_volume)


func get_master_volume_mute() -> bool:
	return config_file.get_value("audio", "mute_master_volume", default_is_master_volume_mute)


func get_sfx_volume() -> float:
	return config_file.get_value("audio", "sfx_volume", default_sfx_volume)


func get_sfx_volume_mute() -> bool:
	return config_file.get_value("audio", "mute_sfx_volume", default_is_sfx_volume_mute)


func get_music_volume() -> float:
	return config_file.get_value("audio", "music_volume", default_music_volume)


func get_music_volume_mute() -> bool:
	return config_file.get_value("audio", "mute_music_volume", default_is_music_volume_mute)


func get_window_mode() -> int:
	return config_file.get_value("video", "window_mode", default_window_mode)


func get_resolution() -> int:
	return config_file.get_value("video", "resolution", default_resolution_mode)


func get_language() -> String:
	return config_file.get_value("language", "language", default_language)

	
func save_settings(master_volume: float, is_master_volume_mute: bool, 
					sfx_volume: float, is_sfx_volume_mute: bool, 
					music_volume: float, is_music_volume_mute: bool,
					window_mode: int, resolution_mode: int, language : String):
	config_file.set_value("audio", "master_volume", master_volume)
	config_file.set_value("audio", "sfx_volume", sfx_volume)
	config_file.set_value("audio", "music_volume", music_volume)
	
	config_file.set_value("audio", "mute_master_volume", is_master_volume_mute)
	config_file.set_value("audio", "mute_sfx_volume", is_sfx_volume_mute)
	config_file.set_value("audio", "mute_music_volume", is_music_volume_mute)
	
	config_file.set_value("video", "window_mode", window_mode)
	config_file.set_value("video", "resolution", resolution_mode)
	
	config_file.set_value("language", "language", language)
	
	var error: int = config_file.save(config_path)
	if error == OK:
		apply_settings(master_volume, is_master_volume_mute,
						sfx_volume, is_sfx_volume_mute,
						music_volume, is_music_volume_mute,
						window_mode, resolution_mode, language)
	else:
		push_error("Failed to save settings: %d" % error)
	
