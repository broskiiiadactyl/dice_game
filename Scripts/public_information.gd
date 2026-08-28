extends Node

@onready var bettingbot : Node = %"Betting Bot"
@onready var main : Node = get_parent()
@onready var last_quantity = Globals.last_quantity
@onready var last_face = Globals.last_face

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

var last_bidder : String = "player"

const turn_order = ["player", "npc1", "npc2", "npc3"]
var turn_pos : int = 0
var remaining_players : int = 4

var final_pool : Array = []
var filtered_final_pool : Array = []

func _ready() -> void:
	bettingbot.lock_bet.connect(_set_player_bid)
	pass

#turn management-------------------
func start_round() -> void:
	for x in results_dict.keys(): #roll the dice for npcs
		if results_dict[x] == []:
			set_npc_dice(x)

func next_turn() -> void:
	turn_pos + 1

func end_round() -> void:
	for x in results_dict.keys():
		results_dict[x].clear()
	last_quantity = 0
	last_face = 0
	pass

func set_dice_value( dice_value, target: = "player") -> void:
	var target_dict = results_dict[target]
	if !dice_value:
		push_error("Error: set_dice was called in player_die but no value was passed through.")
	if target_dict.size() >= handsize_dict[target]:
		push_error("Error: Attempting to add values to a hand when the hand is full.")
		return
	target_dict.append(dice_value)

#bid information -------------
func _set_player_bid(amount: int, face: int, bidder := "player") -> void:
	print("Player bid is: "+str(amount) +" "+str(face)+"s")
	last_quantity = amount
	last_face = face
	last_bidder = bidder

func set_last_quantity(current) -> void: #note: potentially shift bids to a dictionary revolving around npcs
	last_quantity = current

func set_last_face(current) -> void:
	last_face = current

#determining dice values --------
func set_npc_dice(npc) -> void:
	if !npc:
		push_error("Error: set_npc_dice was called but there was no paramater for npc variable.")
	
	var roll = 0
	
	results_dict[npc].clear() #clear the array, then generate a number for each dice they have left
	for dice in range(handsize_dict[npc]):
		roll = randi_range(1,6)
		set_dice_value(roll, npc)

func get_player_value() -> void:
	var dice_array = %"Player Dice".get_children()
	if dice_array == []:
		push_error("Error: You tried to check the value of the player's dice but the dice haven't been rolled yet.")
	results_dict["player"].clear()
	for die in %"Player Dice".get_children():
		set_dice_value(die.dice_value)


#game functions ------------------
func declare_game_state():
	var game_state_string = ""
	for property_info in self.get_script().get_script_property_list():
		var var_name = property_info.name
		var var_value = self.get(var_name)
		var curr_prop = str(var_name) + " = " + str(var_value)
		game_state_string = game_state_string + "\n" + curr_prop
	return game_state_string
	
func resolve_challenge(chal :="player") -> void:
	var round_result : String
	
	final_pool.clear()
	
	for keys in results_dict.keys():
		for val in results_dict[keys]:
			final_pool.append(val)
	filtered_final_pool = final_pool.filter( func(number): return number == last_face)
	if last_quantity <= filtered_final_pool.size(): #if the last bid was equal to or less than the final pool
		round_result = last_bidder
	else:
		round_result = chal
	
	handsize_dict[round_result] = handsize_dict[round_result] - 1 #reduces the losing player's handsize by one hand sizes
