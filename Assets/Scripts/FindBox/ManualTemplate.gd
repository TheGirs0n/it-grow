extends Control
class_name ManualTemplate

@export var plant_description : Array[PlantResource]

@export_group("Book Texture")
@export var book_texture : TextureRect
@export var book_texture_title : CompressedTexture2D
@export var book_texture_open : CompressedTexture2D

@export_group("Texts")
@export var first_text : RichTextLabel
@export var second_text : RichTextLabel

@export_group("Start Pages")
@export var start_first_page : int = 0
@export var start_second_page : int = 1

@export_group("Change Page Buttons")
@export var prev_page_button : Button
@export var next_page_button : Button

var current_first_page = 0
var current_second_page = 1

var is_book_on_title : bool

func open_start():
	open_book_title()
	change_text(current_first_page, current_second_page)

func _on_prev_pressed() -> void:
	if current_first_page != 0:
		current_first_page -= 2
		current_second_page -= 2
	
	GlobalAudio.play_page_prev()
	change_text(current_first_page, current_second_page)

func _on_next_pressed() -> void:
	if current_second_page != plant_description.size() - 1:
		current_first_page += 2
		current_second_page += 2

	GlobalAudio.play_page_next()
	change_text(current_first_page, current_second_page)

func change_text(new_first_page_id : int, new_second_page_id : int):
	first_text.text = plant_description[new_first_page_id].plant_description
	second_text.text = plant_description[new_second_page_id].plant_description


func _on_close_pressed() -> void:
	GlobalAudio.play_book_close()
	hide()


func _on_background_texture_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				if is_book_on_title:
					open_book_page()
				else:
					_on_close_pressed()
					
func open_book_title():
	is_book_on_title = true
	
	first_text.hide()
	second_text.hide()
	
	prev_page_button.hide()
	next_page_button.hide()
	
	book_texture.texture = book_texture_title

func open_book_page():
	is_book_on_title = false
	
	first_text.show()
	second_text.show()
	
	prev_page_button.show()
	next_page_button.show()
	
	book_texture.texture = book_texture_open
