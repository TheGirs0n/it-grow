extends Control
class_name PlantTemplate

@export_multiline var plant_name : String
@export_multiline var plant_description : String
@export var plant_grow_stage_textures : Array[CompressedTexture2D]
@export var plant_smell : GlobalEnums.PLANT_SMELL
@export var plant_leaf : GlobalEnums.PLANT_LEAF
@export var plant_juice_density : GlobalEnums.PLANT_JUICE_DENSITY
@export var plant_juice_color : GlobalEnums.PLANT_JUICE_COLOR
@export var plant_care_stages : Dictionary[GlobalEnums.PLANT_CARE_TYPE, bool]

func load_data_from_resource(new_resouce : PlantResource):
	plant_name = new_resouce.plant_name
	plant_description = new_resouce.plant_description
	plant_grow_stage_textures = new_resouce.plant_grow_stage_textures
	plant_smell = new_resouce.plant_smell
	plant_leaf = new_resouce.plant_leaf
	plant_juice_density = new_resouce.plant_juice_density
	plant_juice_color = new_resouce.plant_juice_color
	
	for i in new_resouce.plant_care_stages:
		plant_care_stages.keys().append(i)
		plant_care_stages[i] = false
	
	
func reset_care_routine():
	for i in plant_care_stages:
		plant_care_stages[i] = false


func try_caring_plant(care_item : CareBoxItem):
	if !plant_care_stages.keys().has(care_item.plant_care_type):
		# ошибка игрока
		return
	else:
		var current_stage = plant_care_stages[care_item.plant_care_type]

func get_plant_name() -> String:
	return plant_name
	
func get_plant_description() -> String:
	return plant_description
	
func get_plant_smell() -> GlobalEnums.PLANT_SMELL:
	return plant_smell
	
func get_plant_leaf() -> GlobalEnums.PLANT_LEAF:
	return plant_leaf
	
func get_plant_juice_density() -> GlobalEnums.PLANT_JUICE_DENSITY:
	return plant_juice_density
	
func get_plant_juice_color() -> GlobalEnums.PLANT_JUICE_COLOR:
	return plant_juice_color
	
func get_plant_care_stages() -> Array[GlobalEnums.PLANT_CARE_TYPE]:
	return plant_care_stages.keys()
