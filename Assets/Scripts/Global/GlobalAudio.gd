extends Node

@onready var bag: AudioStreamPlayer = $Bag
@onready var book_close: AudioStreamPlayer = $BookClose
@onready var book_open: AudioStreamPlayer = $BookOpen
@onready var page_next: AudioStreamPlayer = $PageNext
@onready var page_prev: AudioStreamPlayer = $PagePrev
@onready var leafs: AudioStreamPlayer = $Leafs
@onready var knife: AudioStreamPlayer = $Knife
@onready var lose: AudioStreamPlayer = $Lose
@onready var magnifier_use: AudioStreamPlayer = $MagnifierUse
@onready var magnifier_take: AudioStreamPlayer = $MagnifierTake
@onready var new_plants: AudioStreamPlayer = $NewPlants
@onready var plants_grow: AudioStreamPlayer = $PlantsGrow
@onready var rake_take: AudioStreamPlayer = $RakeTake
@onready var rake_use: AudioStreamPlayer = $RakeUse
@onready var watering_can_use: AudioStreamPlayer = $WateringCanUse
@onready var watering_can_take: AudioStreamPlayer = $WateringCanTake
@onready var win: AudioStreamPlayer = $Win
@onready var main_theme: AudioStreamPlayer = $MainTheme
@onready var button_hovered: AudioStreamPlayer = $ButtonHovered

func play_main_theme():
	main_theme.play()

func play_page_next():
	page_next.play()
	
func play_page_prev():
	page_prev.play()

func play_leafs():
	leafs.play()

func play_magnifier_use():
	magnifier_use.play()

func play_magnifier_take():
	magnifier_take.play()
	
func play_new_plant():
	new_plants.play()
	
func play_plants_grow():
	plants_grow.play()

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

func play_watering_can_take():
	watering_can_take.play()
	
func play_watering_can_use():
	watering_can_use.play()

func play_rake_take():
	rake_take.play()
	
func play_rake_use():
	rake_use.play()
	
func play_win():
	win.play()
	
func play_button_hover():
	button_hovered.play()
