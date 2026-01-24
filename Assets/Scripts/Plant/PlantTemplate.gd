extends Area2D
class_name PlantTemplate

@export var plant_texture : Sprite2D
@export var plant_circle : FindBoxCircleUI

var plant_name : String
var plant_energy : GlobalEnums.PLANT_ENERGY
var plant_description : String
var plant_grow_stage_textures : Array[CompressedTexture2D]
var plant_smell : String
var plant_leaf : CompressedTexture2D
var plant_juice_density : CompressedTexture2D
var plant_juice_color : String
var plant_additional_propety : String
var plant_care_stages : Array[GlobalEnums.PLANT_CARE_TYPE]

var plant_care_stages_complete : Array[bool]
var plant_care_stages_index = 0

func _ready() -> void:
	load_data_from_resource(PlantResourceFabric.get_random_plant_resource())

func load_data_from_resource(new_resouce : PlantResource):
	plant_name = new_resouce.plant_name
	plant_energy = new_resouce.plant_energy
	plant_description = new_resouce.plant_description
	plant_grow_stage_textures = new_resouce.plant_grow_stage_textures
	plant_smell = new_resouce.plant_smell
	plant_leaf = new_resouce.plant_leaf
	plant_juice_density = new_resouce.plant_juice_density
	plant_juice_color = new_resouce.plant_juice_color
	plant_additional_propety = new_resouce.plant_additional_property
	plant_care_stages = new_resouce.plant_care_stages
	
	for i in new_resouce.plant_care_stages:
		plant_care_stages_complete.append(false)
	

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if plant_circle.visible == false:
					plant_circle.show()
					return
				
				if GlobalContext.main_ui_instance.care_box_ui.current_care_box_item == null:
					print("NO ITEM") # Уход
				else:
					try_caring_plant(GlobalContext.main_ui_instance.care_box_ui.current_care_box_item)
					GlobalContext.main_ui_instance.care_box_ui.clear_current_care_box_item()
					return
				
				if GlobalContext.main_ui_instance.find_box_ui.current_find_box_item == null:
					print("NO FIND ITEM") # Распознавание
				else:
					try_find_item(GlobalContext.main_ui_instance.find_box_ui.current_find_box_item)
					GlobalContext.main_ui_instance.find_box_ui.clear_current_find_box_item()
					return
	
	
func reset_care_routine():
	plant_care_stages_complete.fill(false)


func try_caring_plant(care_item : CareBoxItem):
	if plant_care_stages_complete.find(false) == -1:
		increase_grow_stage()
		return
	
	if !plant_care_stages.has(care_item.plant_care_type):
		print("НЕТ ТАКОГО В ИНСТРУКЦИИ")
		decrease_grow_stage()
		return
	
	var current_stage = plant_care_stages_complete.find(false)
	if plant_care_stages[current_stage] == care_item.plant_care_type:
		plant_care_stages_complete[current_stage] = true
		print("ОТЛИЧНЫЙ УХОД")
	else:
		print("ОШИБКА УХОДА")
		decrease_grow_stage()

func try_find_item(find_item : FindBoxItem):
	match find_item.find_box_type:
		GlobalEnums.PLANT_FIND_TYPE.NOSE:
			GlobalContext.main_ui_instance.show_tooltip(plant_smell)
			plant_circle.hide()
			print("SMELL")
		GlobalEnums.PLANT_FIND_TYPE.BRAIN:
			GlobalContext.main_ui_instance.show_tooltip(plant_additional_propety)
			plant_circle.hide()
			print("PROP")
		GlobalEnums.PLANT_FIND_TYPE.KNIFE:
			GlobalContext.main_ui_instance.show_tooltip(str(plant_juice_density))
			GlobalContext.main_ui_instance.open_find_box_center(plant_grow_stage_textures[plant_care_stages_index], plant_juice_density)
			print("JUICE")
		GlobalEnums.PLANT_FIND_TYPE.MAGNIFIER:
			GlobalContext.main_ui_instance.open_find_box_center(plant_grow_stage_textures[plant_care_stages_index], plant_leaf)
			print("GROW")


func increase_grow_stage():
	if plant_care_stages_index < plant_care_stages.size():
		plant_care_stages_index += 1
		plant_texture.texture = plant_grow_stage_textures[plant_care_stages_index]
		reset_care_routine()
	else:
		print("ЦВЕТКУ БОЛЬШЕ НЕКУДА РАСТИ")

func decrease_grow_stage():
	if plant_care_stages_index > 0:
		plant_care_stages_index -= 1
		plant_texture.texture = plant_grow_stage_textures[plant_care_stages_index]
		GlobalContext.game_manager_instance.increase_current_attempts()
	elif plant_care_stages_index == 0:
		plant_care_stages_index = 0
		#plant_texture.texture = plant_grow_stage_textures[0]
		GlobalContext.game_manager_instance.increase_current_attempts()

func get_plant_name() -> String:
	return plant_name
	
func get_plant_description() -> String:
	return plant_description
	
func get_plant_smell() -> String:
	return plant_smell
	
func get_plant_leaf() -> CompressedTexture2D:
	return plant_leaf
	
func get_plant_juice_density() -> CompressedTexture2D:
	return plant_juice_density
	
func get_plant_juice_color() -> String:
	return plant_juice_color

	
func get_plant_care_stages() -> Array[GlobalEnums.PLANT_CARE_TYPE]:
	return plant_care_stages
