extends Area2D
class_name PlantTemplate

@export var plant_resource : PlantResource
@export var plant_texture : Sprite2D
@export var plant_goal_container : PlantGoalContainer

var plant_name : String
var plant_cool_name : String
var plant_energy : String
var plant_description : String
var plant_cool_description : String
var plant_grow_stage_textures : Array[CompressedTexture2D]
var plant_smell : String
var plant_leaf : CompressedTexture2D
var plant_juice_density : CompressedTexture2D
var plant_juice_color : String
var plant_care_stages : Array[GlobalEnums.PLANT_CARE_TYPE]

var plant_care_stages_complete : Array[bool]
var plant_care_stages_index = 0

func _ready() -> void:
	load_data_from_resource()

func load_data_from_resource():
	plant_name = plant_resource.plant_name
	plant_energy = plant_resource.plant_energy
	plant_description = plant_resource.plant_description
	plant_cool_description = plant_resource.plant_cool_description
	plant_grow_stage_textures = plant_resource.plant_grow_stage_textures
	plant_smell = plant_resource.plant_smell
	plant_leaf = plant_resource.plant_leaf
	plant_juice_density = plant_resource.plant_juice_density
	plant_juice_color = plant_resource.plant_juice_color
	plant_care_stages = plant_resource.plant_care_stages
	
	plant_texture.texture = plant_grow_stage_textures[plant_care_stages_index]
	
	for i in plant_resource.plant_care_stages:
		plant_care_stages_complete.append(false)

func _process(_delta: float) -> void:
	if plant_care_stages_complete.find(false) == -1:
		increase_grow_stage()
		return
		
	if input_pickable == true:
		if plant_care_stages_index == plant_grow_stage_textures.size() - 1:
			GlobalContext.main_ui_instance.show_tooltip("Цветок достиг своей абсолютной красоты!")
			GlobalContext.game_manager_instance.set_plant_full(self)
			input_pickable = false
			return
	

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
			
				if GlobalContext.main_ui_instance.care_box_ui.current_care_box_item != null:
					try_caring_plant(GlobalContext.main_ui_instance.care_box_ui.current_care_box_item)
					GlobalContext.main_ui_instance.care_box_ui.clear_current_care_box_item()
					return
				
				if GlobalContext.main_ui_instance.find_box_ui.current_find_box_item != null:
					try_find_item(GlobalContext.main_ui_instance.find_box_ui.current_find_box_item)
					GlobalContext.main_ui_instance.find_box_ui.clear_current_find_box_item()
					return
					
				if GlobalContext.main_ui_instance.find_box_circle_center_add.visible == false:
					GlobalContext.main_ui_instance.open_find_box_center_add(self)
	
func reset_care_routine():
	plant_care_stages_complete.fill(false)
	plant_goal_container.reset_all_circle()


func try_caring_plant(care_item : CareBoxItem):
	if !plant_care_stages.has(care_item.plant_care_type):
		GlobalContext.main_ui_instance.show_tooltip("Кажется нужно попробовать что-то другое...")
		decrease_grow_stage()
		return
	
	var current_stage = plant_care_stages_complete.find(false)
	
	if plant_care_stages[current_stage] == care_item.plant_care_type:
		plant_care_stages_complete[current_stage] = true
		
		match care_item.plant_care_type:
			GlobalEnums.PLANT_CARE_TYPE.FERTILIZER:
				GlobalAudio.play_bag_sound()
			GlobalEnums.PLANT_CARE_TYPE.RAKE:
				GlobalAudio.play_rake_use()
			GlobalEnums.PLANT_CARE_TYPE.WATERING_CAN:
				GlobalAudio.play_watering_can_use()
		
		plant_goal_container.set_done_circle(current_stage)
		plant_goal_container.show_all_circles(plant_care_stages.size())
		GlobalContext.main_ui_instance.show_tooltip("Цветок растет прям на глазах!")
	else:
		decrease_grow_stage()
		GlobalContext.main_ui_instance.show_tooltip("Ох навредила я цветку...")

func try_find_item(find_item : FindBoxItem):
	match find_item.find_box_type:
		GlobalEnums.PLANT_FIND_TYPE.NOSE:
			GlobalContext.main_ui_instance.show_tooltip(plant_smell)
		GlobalEnums.PLANT_FIND_TYPE.BRAIN:
			GlobalContext.main_ui_instance.show_tooltip(plant_energy)
		GlobalEnums.PLANT_FIND_TYPE.KNIFE:
			GlobalAudio.play_knife()
			GlobalContext.main_ui_instance.open_find_box_center(plant_grow_stage_textures[plant_care_stages_index], plant_juice_density)
		GlobalEnums.PLANT_FIND_TYPE.MAGNIFIER:
			GlobalAudio.play_bag_sound()
			GlobalContext.main_ui_instance.open_find_box_center(plant_grow_stage_textures[plant_care_stages_index], plant_leaf)


func increase_grow_stage():
	if plant_grow_stage_textures.size() == 1:
		GlobalContext.main_ui_instance.show_tooltip("Цветок достиг своей абсолютной красоты!")
		input_pickable = false
		return
	elif plant_care_stages_index == plant_grow_stage_textures.size() - 1:
		GlobalContext.main_ui_instance.show_tooltip("Цветок достиг своей абсолютной красоты!")
		input_pickable = false
		return
	
	if plant_care_stages_index < plant_grow_stage_textures.size():
		GlobalAudio.play_plants_grow()
		plant_care_stages_index += 1
		plant_texture.texture = plant_grow_stage_textures[plant_care_stages_index]
		reset_care_routine()
		

func decrease_grow_stage():
	if plant_care_stages_index > 0:
		plant_care_stages_index -= 1
		plant_texture.texture = plant_grow_stage_textures[plant_care_stages_index]
		GlobalContext.game_manager_instance.decrease_current_attempts()
		plant_goal_container.reset_all_circle()
		reset_care_routine()
	elif plant_care_stages_index == 0:
		plant_care_stages_index = 0
		plant_texture.texture = plant_grow_stage_textures[0]
		GlobalContext.game_manager_instance.decrease_current_attempts()
		reset_care_routine()
