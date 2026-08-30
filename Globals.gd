extends Node

var can_move : bool = true

var ran_test : bool = false

var dice_dict : Dictionary = {
	"normal": "res://Assets/Dice/Scenes/models/normal_die.tscn",
	"inset": "res://Assets/Dice/Scenes/models/inset_die.tscn",
}

var cup_dict : Dictionary = {
	"can": "res://Assets/Cups/Scenes/can_open_2.tscn",
	"wood": "res://Assets/Cups/Scenes/player_cup_model.tscn"
}

const num_conversion = {
	1 : 'One',
	2 : 'Two',
	3 : 'Three',
	4 : 'Four',
	5 : 'Five',
	6 : 'Six',
}

signal playmat_button_pressed(type: String)
signal main_loaded
signal speak(args: Array[Array])
signal speak_finished
signal bot_left
signal unpause

#public information variables that need to be declared
var last_quantity : int = 0
var last_face : int = 0
