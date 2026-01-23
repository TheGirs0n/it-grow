extends Control
class_name GameOverMiniGameUI

@export_group("Container")
@export var container : HBoxContainer

@export_group("Text Group")
@export var number_next : RichTextLabel
@export var more_than_button : TextureButton
@export var equal_button : TextureButton
@export var less_than_button : TextureButton

@export_group("Next Stage Button")
@export var next_stage : Button

@export_group("Dice Value")
@export var dice_number_text : RichTextLabel 

@export_group("Balance Things")
@export var max_round_for_win : int = 3

enum MINI_GAME_MODE{
	MORE_THAN,
	LESS_THAN,
	EQUAL
}

var current_score : int = 0
var current_round : int = 1
var current_number : int = 0
var mini_game_mode : MINI_GAME_MODE

func _ready() -> void:
	prepare_mini_game()
	

func prepare_mini_game():
	current_number = randi_range(5, 9)
	number_next.text = str(current_number)
	
	more_than_button.show()
	equal_button.show()
	less_than_button.show()
	
	more_than_button.disabled = false
	equal_button.disabled = false
	less_than_button.disabled = false
	
	mini_game_mode = MINI_GAME_MODE.MORE_THAN
	next_stage.hide()
	
	current_score = 0
	current_round = 1

func reset_mini_game():
	current_number = randi_range(5, 9)
	number_next.text = str(current_number)
	current_round += 1
	dice_number_text.text = ""
	
	more_than_button.show()
	equal_button.show()
	less_than_button.show()
	
	more_than_button.disabled = false
	equal_button.disabled = false
	less_than_button.disabled = false
	
	mini_game_mode = MINI_GAME_MODE.MORE_THAN
	next_stage.hide()

func _on_more_button_pressed() -> void:
	mini_game_mode = MINI_GAME_MODE.MORE_THAN
	
	less_than_button.hide()
	equal_button.hide()
	more_than_button.disabled = true
	
	roll_dice()

func _on_less_button_pressed() -> void:
	mini_game_mode = MINI_GAME_MODE.LESS_THAN
	
	more_than_button.hide()
	equal_button.hide()
	less_than_button.disabled = true
	
	roll_dice()

func _on_equal_button_pressed() -> void:
	mini_game_mode = MINI_GAME_MODE.EQUAL

	more_than_button.hide()
	less_than_button.hide()
	equal_button.disabled = true

	roll_dice()
	

func roll_dice():
	var first_number = randi_range(1, 6)
	var second_number = randi_range(1, 6)
	
	var sum = first_number + second_number
	
	dice_number_text.text = str(sum)
	
	match mini_game_mode:
		MINI_GAME_MODE.MORE_THAN:
			if sum > current_number:
				print("WIN")
				increase_score(1)
			else:
				print("LOSE")
		MINI_GAME_MODE.LESS_THAN:
			if sum < current_number:
				print("WIN")
				increase_score(1)
			else:
				print("LOSE")
			pass
		MINI_GAME_MODE.EQUAL:
			if sum == current_number:
				print("WIN")
				increase_score(3)
			else:
				print("LOSE")
			pass
	
	check_win()

func increase_score(incoming_score : int):
	if incoming_score == 3:
		return
	
	current_score += incoming_score


func check_win():
	if current_score >= 2:
		print("WIN")
	else: 
		print("CHECK")
		
	if current_round == 3:
		container.hide()
		print("LOSE")
	else:
		next_stage.show()

func _on_next_stage_pressed() -> void:
	reset_mini_game()
