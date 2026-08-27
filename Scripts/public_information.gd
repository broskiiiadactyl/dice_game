extends Node

@onready var bettingbot : Node = %"Betting Bot"
@onready var main : Node = get_parent()

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

var last_quantity := 3
var last_face := 3

const turn_order = ["player", "npc1", "npc2", "npc3"]
var turn_pos : int = 0

var final_pool : Array = []
var filtered_final_pool : Array = []

var round_result : bool = false #true for win, false for loss

func _ready() -> void:
	bettingbot.lock_bet.connect(_set_player_bid)
	pass

#lock_bet(amount: int, face: int) -> signal

func start_round() -> void:
	main.fukcing_roll_hellllll_yeah()
	for x in results_dict.keys():
		if results_dict[x] == []:
			set_npc_dice(x)

func next_turn() -> void:
	turn_pos + 1

func set_dice_value( dice_value, target: = "player") -> void:
	var target_dict = results_dict[target]
	if !dice_value:
		push_error("Error: set_dice was called in player_die but no value was passed through.")
	if target_dict.size() >= handsize_dict[target]:
		push_error("Error: Attempting to add values to a hand when the hand is full.")
		return
	target_dict.append(dice_value)

#bid information
func _set_player_bid(amount: int, face: int) -> void:
	print("Player bid is: "+str(amount) +" "+str(face)+"s")
	last_quantity = amount
	last_face = face

func set_last_quantity(current) -> void: #note: potentially shift bids to a dictionary revolving around npcs
	last_quantity = current

func set_last_face(current) -> void:
	last_face = current

#determining dice values
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

func declare_game_state():
	var game_state_string = ""
	for property_info in self.get_script().get_script_property_list():
		var var_name = property_info.name
		var var_value = self.get(var_name)
		var curr_prop = str(var_name) + " = " + str(var_value)
		game_state_string = game_state_string + "\n \n" + curr_prop
	return game_state_string
	
func resolve_challenge() -> void:
	final_pool.clear()
	for keys in results_dict.keys():
		for val in results_dict[keys]:
			final_pool.append(val)
	filtered_final_pool = final_pool.filter( func(number): return number == last_face)
	if last_quantity <= filtered_final_pool.size():
		round_result = true
