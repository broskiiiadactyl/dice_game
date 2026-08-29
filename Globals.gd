extends Node

var can_move : bool = true

var ran_test : bool = false

var dice_dict : Dictionary = {
	"normal": "res://Assets/Dice/Scenes/models/normal_die.tscn",
	"inset": "res://Assets/Dice/Scenes/models/inset_die.tscn"
}

var cup_dict : Dictionary = {
	"can": "res://Assets/Cups/Scenes/can_open_2.tscn"
}

signal playmat_button_pressed(type: String)
signal main_loaded
signal speak(args: Array[Array])
signal speak_finished
signal bot_left

#public information variables that need to be declared
var last_quantity : int = 0
var last_face : int = 0
