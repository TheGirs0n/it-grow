extends Node

var config_file : ConfigFile
var config_path : String = "user://settings.cfg"

func _enter_tree() -> void:
	load_setting_at_startup()

func load_setting_at_startup():
	config_file = ConfigFile.new()
	var is_have_config = config_file.load(config_path)
	
	if is_have_config != OK:
		apply_default_setting()
		
	apply_setting_from_config()
	
func apply_setting_from_config():
	var master_volume : float = config_file.get_value("audio", "master_volume", 50.0)
	var sfx_volume : float = config_file.get_value("audio", "sfx_volume", 50.0)
	var music_volume : float = config_file.get_value("audio", "music_volume", 50.0)
	
	var window_mode : int = config_file.get_value("video", "window_mode", 1)
	var resolution_mode : int = config_file.get_value("video", "resolution", 0)
	
	apply_settings(master_volume, sfx_volume, music_volume, window_mode, resolution_mode)
	
func apply_default_setting():
	apply_settings(50.0, 50.0, 50.0, 1, 0)
	
func apply_settings(master_volume: float, sfx_volume: float, music_volume: float,
					window_mode: int, resolution: int):
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume / 100.0))
	AudioServer.set_bus_volume_db(1, linear_to_db(sfx_volume / 100.0))
	AudioServer.set_bus_volume_db(2, linear_to_db(music_volume / 100.0))
	
	apply_window_mode(window_mode)
	apply_resolution(resolution, window_mode)
	
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
		Vector2i(1920, 1080)
	]
	
	if index < 0 or index >= resolutions.size():
		return
	
	DisplayServer.window_set_size(resolutions[index])
	center_window()
	
func center_window() -> void:
	var screen: Vector2i = DisplayServer.screen_get_size()
	var win: Vector2i = DisplayServer.window_get_size()
	
	var center: Vector2i = Vector2i(
		(screen.x - win.x) / 2,
		(screen.y - win.y) / 2
	)
	
	DisplayServer.window_set_position(center)
	
func get_master_volume() -> float:
	return config_file.get_value("audio", "master_volume", 50.0)


func get_sfx_volume() -> float:
	return config_file.get_value("audio", "sfx_volume", 50.0)


func get_music_volume() -> float:
	return config_file.get_value("audio", "music_volume", 50.0)


func get_window_mode() -> int:
	return config_file.get_value("video", "window_mode", 1)


func get_resolution() -> int:
	return config_file.get_value("video", "resolution", 0)
	
func save_settings(master_volume: float, sfx_volume: float, music_volume: float,
				  window_mode: int, resolution: int):
	config_file.set_value("audio", "master_volume", master_volume)
	config_file.set_value("audio", "sfx_volume", sfx_volume)
	config_file.set_value("audio", "music_volume", music_volume)
	
	config_file.set_value("video", "window_mode", window_mode)
	config_file.set_value("video", "resolution", resolution)
	
	var error: int = config_file.save(config_path)
	if error == OK:
		apply_settings(master_volume, sfx_volume, music_volume, window_mode, resolution)
	else:
		push_error("Failed to save settings: %d" % error)
	
