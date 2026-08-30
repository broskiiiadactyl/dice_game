extends Node3D

@onready var dice_display : Control = %"Dice Display"
@onready var call_display : Control = %Call
@onready var think_display : Control = %Think
@onready var bet_display : Control = %Bet
@onready var out_display : Control = %Out

var num_of_dice : int
var is_calling : bool = false
var is_passing : bool = false
var is_out : bool = false
var playing_text : bool = false

@onready var faces : Array[CompressedTexture2D] = [
	load("res://Assets/theme styling/die1.png"),
	load("res://Assets/theme styling/die2.png"),
	load("res://Assets/theme styling/die3.png"),
	load("res://Assets/theme styling/die4.png"),
	load("res://Assets/theme styling/die5.png"),
	load("res://Assets/theme styling/die6.png")
]

#NOTE from J: I put a script on the layer above this that sorts out which npc it's sending to
#NOTE from J: it's sort_npc_screen_update(), and I call to it

#Call this function to update the screen
#To simply update # of dice, pass any garbage string and the number of dice
#To signal a bet, call AFTER setting Globals.last_quantity and Globals.last_face
func update_screen(status : String, active: int = num_of_dice) -> bool:
	match status:
		"call":
			await play_text(call_display)
		"bet":
			%"Bet Num".text = str(Globals.last_quantity)
			%"Bet Face".texture = faces[Globals.last_face - 1]
			await play_text(bet_display)
		"think":
			await play_text(think_display)
		"out":
			dice_display.visible = false
			dice_display.visible = false
			call_display.visible = false
			think_display.visible = false
			bet_display.visible = false
			out_display.visible = true
		_:
			num_of_dice = active
			for die in dice_display.get_children():
				if int(die.name) > active:
					die.modulate = Color(1.0, 1.0, 1.0, 0.255) 
			dice_display.visible = true
	
	return true

func play_text(display) -> bool:
	while not playing_text:
		await get_tree().create_timer(0.5).timeout
	playing_text = true
	dice_display.visible = false
	
	for i in range(3):
		display.visible = true
		await get_tree().create_timer(0.5).timeout
		display.visible = false
		await get_tree().create_timer(0.5).timeout
	
	dice_display.visible = true
	playing_text = false
	return true
