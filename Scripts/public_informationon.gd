extends Node

var results_dict = {
	"player" : [],
	"npc1" : [],
	"npc2" : [],
	"npc3" : []
}

var handsize_dict = {
	"player" : 5,
	"npc1" : 5,
	"npc2" : 5,
	"npc3" : 5
}

var last_quantity := 0
var last_face := 0
var last_bid := [0,0]

var turn_order = ["player", "npc1", "npc2", "npc3"]

func _ready():
	pass

func start_game():
	pass

func set_dice_value( dice_value, target: = "player"):
	if !dice_value:
		push_error("Error: set_dice was called in player_die but no value was passed through.")
	
	results_dict[target].append(dice_value)

#note: potentially shift bids to a dictionary revolving around npcs
func set_last_quantity(current):
	last_quantity = current

func set_last_face(current):
	last_face = current

func set_last_bid():
	last_bid = [last_quantity,last_face]

func declare_game_state():
	var game_state_string = ""
	for property_info in self.get_script().get_script_property_list():
		var var_name = property_info.name
		var var_value = self.get(var_name)
		var curr_prop = str(var_name) + " = " + str(var_value)
		game_state_string = game_state_string + "\n \n" + curr_prop
	return game_state_string

func determine_npc_dice(npc):
	if !npc:
		push_error("Error: determine_npc_dice was called but there was no paramater for npc variable.")
	
	var roll = 0
	
	#clear the array, then generate a number for each dice they have left
	results_dict[npc].clear()
	for dice in range(handsize_dict[npc]):
		roll = randi_range(1,6)
		set_dice_value(roll, npc)
