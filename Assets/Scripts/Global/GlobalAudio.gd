extends Node

@onready var bag: AudioStreamPlayer = $Bag
@onready var book_close: AudioStreamPlayer = $BookClose
@onready var book_open: AudioStreamPlayer = $BookOpen
@onready var knife: AudioStreamPlayer = $Knife
@onready var lose: AudioStreamPlayer = $Lose
@onready var rake_take: AudioStreamPlayer = $RakeTake
@onready var rake_use: AudioStreamPlayer = $RakeUse
@onready var win: AudioStreamPlayer = $Win

func play_bag_sound():
	bag.play()
	
func play_book_close():
	book_close.play()
	
func play_book_open():
	book_open.play()
	
func play_knife():
	knife.play()
	
func play_lose():
	lose.play()

func play_rake_take():
	rake_take.play()
	
func play_rake_use():
	rake_use.play()
	
func play_win():
	win.play()
