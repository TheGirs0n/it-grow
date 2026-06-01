extends Area2D
class_name PlantTemplate

@export var plant_resource: PlantResource
@export var plant_texture: Sprite2D
@export var plant_goal_container: PlantGoalContainer

var plant_name: String
var plant_cool_name: String
var plant_energy: String
var plant_description: String
var plant_cool_description: String
var plant_grow_stage_textures: Array[CompressedTexture2D]
var plant_smell: String
var plant_leaf: Array[CompressedTexture2D]
var plant_juice_density: Array[CompressedTexture2D]
var plant_care_stages: Array[GlobalEnums.PLANT_CARE_TYPE]

var plant_care_stages_complete: Array[bool]
var plant_care_stages_index: int = 0

var is_plant_full_grow: bool = false

# Прямая ссылка нужна для синхронного чтения current_care_box_item / current_find_box_item
# в обработчиках ввода — EventBus здесь не подходит (push, не pull)
var _main_ui: MainUI


func setup(main_ui: MainUI) -> void:
	_main_ui = main_ui


func _ready() -> void:
	load_data_from_resource()


func load_data_from_resource() -> void:
	plant_name = plant_resource.plant_name
	plant_energy = plant_resource.plant_energy
	plant_description = plant_resource.plant_description
	plant_cool_description = plant_resource.plant_cool_description
	plant_grow_stage_textures = plant_resource.plant_grow_stage_textures
	plant_smell = plant_resource.plant_smell
	plant_leaf = plant_resource.plant_leaf
	plant_juice_density = plant_resource.plant_juice_density
	plant_care_stages = plant_resource.plant_care_stages

	plant_texture.texture = plant_grow_stage_textures[plant_care_stages_index]

	for _i in plant_resource.plant_care_stages:
		plant_care_stages_complete.append(false)


# FIX: убрали _process с опросом массива каждый кадр.
# Проверка завершённости стадии теперь вызывается только из try_caring_plant()
# после фактического изменения состояния.


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not (event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.is_pressed():
		return

	if not is_plant_full_grow:
		_handle_click_growing()
	else:
		_handle_click_grown()


func _handle_click_growing() -> void:
	if _main_ui.care_box_ui.current_care_box_item != null:
		try_caring_plant(_main_ui.care_box_ui.current_care_box_item)
		EventBus.care_item_clear_requested.emit()
		return

	if _main_ui.find_box_ui.current_find_box_item != null:
		try_find_item(_main_ui.find_box_ui.current_find_box_item)
		EventBus.find_item_clear_requested.emit()
		return

	if not _main_ui.find_box_circle_center_add.visible:
		EventBus.find_box_center_add_show.emit(self)


func _handle_click_grown() -> void:
	if _main_ui.care_box_ui.current_care_box_item != null:
		EventBus.tooltip_show.emit("За цветком больше не нужно ухаживать!")
		EventBus.care_item_clear_requested.emit()
		return

	if _main_ui.find_box_ui.current_find_box_item != null:
		EventBus.tooltip_show.emit("За цветком больше не нужно ухаживать!")
		EventBus.find_item_clear_requested.emit()
		return

	if not _main_ui.find_box_circle_center_add.visible:
		EventBus.find_box_center_full_grow_show.emit(self)


func reset_care_routine() -> void:
	plant_care_stages_complete.fill(false)
	plant_goal_container.reset_all_circle()


func try_caring_plant(care_item: CareBoxItem) -> void:
	if not plant_care_stages.has(care_item.plant_care_type):
		EventBus.tooltip_show.emit("Кажется нужно попробовать что-то другое...")
		decrease_grow_stage()
		return

	var current_stage := plant_care_stages_complete.find(false)

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
		EventBus.tooltip_show.emit("Цветок растет прям на глазах!")

		# FIX: проверка вместо _process-опроса — срабатывает только когда нужно
		_check_stage_complete()
	else:
		decrease_grow_stage()
		EventBus.tooltip_show.emit("Ох навредила я цветку...")


func _check_stage_complete() -> void:
	if plant_care_stages_complete.find(false) != -1:
		return

	if plant_care_stages_index == plant_grow_stage_textures.size() - 1:
		EventBus.tooltip_show.emit("Цветок достиг своей абсолютной красоты!")
		EventBus.plant_fully_grown.emit(self)
		is_plant_full_grow = true
	else:
		increase_grow_stage()


func try_find_item(find_item: FindBoxItem) -> void:
	match find_item.find_box_type:
		GlobalEnums.PLANT_FIND_TYPE.NOSE:
			EventBus.tooltip_show.emit(plant_smell)
		GlobalEnums.PLANT_FIND_TYPE.BRAIN:
			EventBus.tooltip_show.emit(plant_energy)
		GlobalEnums.PLANT_FIND_TYPE.KNIFE:
			GlobalAudio.play_knife()
			EventBus.find_box_center_show.emit(
				plant_grow_stage_textures[plant_care_stages_index],
				plant_juice_density[plant_care_stages_index]
			)
		GlobalEnums.PLANT_FIND_TYPE.MAGNIFIER:
			GlobalAudio.play_bag_sound()
			EventBus.find_box_center_show.emit(
				plant_grow_stage_textures[plant_care_stages_index],
				plant_leaf[plant_care_stages_index]
			)


func increase_grow_stage() -> void:
	if plant_care_stages_index < plant_grow_stage_textures.size() - 1:
		GlobalAudio.play_plants_grow()
		GlobalParticles.spawn_particles(self)
		plant_care_stages_index += 1
		plant_texture.texture = plant_grow_stage_textures[plant_care_stages_index]
		reset_care_routine()


func decrease_grow_stage() -> void:
	if plant_care_stages_index > 0:
		plant_care_stages_index -= 1
		plant_texture.texture = plant_grow_stage_textures[plant_care_stages_index]
		plant_goal_container.reset_all_circle()
		reset_care_routine()
	else:
		# plant_care_stages_index уже 0 — сбрасываем текстуру и рутину
		plant_texture.texture = plant_grow_stage_textures[0]
		# FIX: reset_all_circle отсутствовал в этой ветке → кружки не сбрасывались
		plant_goal_container.reset_all_circle()
		reset_care_routine()

	# Обе ветки уменьшают попытки
	EventBus.plant_grow_failed.emit()
