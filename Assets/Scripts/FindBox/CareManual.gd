extends Control
class_name CareManual

@export var plant_description : Array[PlantResource]

@export_group("Texts")
@export var first_text : RichTextLabel
@export var second_text : RichTextLabel

@export_group("Start Pages")
@export var start_first_page : int = 0
@export var start_second_page : int = 1

var current_first_page = 0
var current_second_page = 1

func open_care_manual():
	change_text(start_first_page, start_second_page)

func _on_prev_pressed() -> void:
	if current_first_page != 0:
		current_first_page -= 2
		current_second_page -= 2
	
	change_text(current_first_page, current_second_page)

func _on_next_pressed() -> void:
	if current_second_page != plant_description.size() - 1:
		current_first_page += 2
		current_second_page += 2

	change_text(current_first_page, current_second_page)

func change_text(new_first_page_id : int, new_second_page_id : int):
	first_text.text = plant_description[new_first_page_id].plant_description
	second_text.text = plant_description[new_second_page_id].plant_description
