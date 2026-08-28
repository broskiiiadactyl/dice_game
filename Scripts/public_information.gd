extends Node

@onready var bettingbot : Node = %"Betting Bot"
@onready var gameactions_label : Node = %"gameactions"
@onready var allbets_label : Node = %"allbets"
@onready var main : Node = get_parent()
@onready var last_quantity = Globals.last_quantity
@onready var last_face = Globals.last_face

signal bid_set

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

var bets_dict = {
}

const name_conversion = {
	"player" : "Major",
	"npc1" : "Slade",
	"npc2" : "Boone",
	"npc3" : "Vickie"
}

const dice_conversion_dict = {
	1 : 'One',
	2 : 'Two',
	3 : 'Three',
	4 : 'Four',
	5 : 'Five',
	6 : 'Six',
}

#last_quantity, last_face are declared in on ready and are linked to the global property
var last_bidder : String = "player"

const turn_order = ["player", "npc1", "npc2", "npc3"]
const char_name = ["Major","Slade","Boone","Vickie"]
var turn_pos : int = 0
var remaining_players : int = 4

var final_pool : Array = []
var filtered_final_pool : Array = []

func _ready() -> void:
	bettingbot.lock_bet.connect(_set_bid)
	pass

#turn management-------------------
func start_round() -> void:
	if results_dict["player" ] == []:
		get_player_value()
	for x in results_dict.keys(): #roll the dice for npcs
		if results_dict[x] == []:
			set_npc_dice(x)
	

func call_phase(npc : String) -> bool:
	var char_name = name_conversion[npc]
	gameactions_label.text = "[shake]"+str(char_name)+" is thinking...[shake]"
	var random_time = randf_range(2.0, 4.0)
	await get_tree().create_timer(random_time).timeout
	if randi_range(1, 10) == 10:
		gameactions_label.text = str(char_name)+" calls. [raindbow]Let's see how this one goes.[rainbow]"
		await get_tree().create_timer(3.0).timeout
		await resolve_challenge() 
	else:
		var curr_bid : Array = get_npc_bid()
		var bet_string = str(char_name)+" bids "+str(curr_bid[0])+" "+str(dice_conversion_dict[curr_bid[1]])+"s \n"
		gameactions_label.text = bet_string
		allbets_label.text = allbets_label.text + bet_string
		await get_tree().create_timer(3.0).timeout
		print(npc+" is the current npc")
		await _set_bid(curr_bid[0],curr_bid[1],npc)
		next_turn()
	return true

func next_turn():
	turn_pos = turn_pos+1
	if turn_pos == 4:
		start_player_turn()
		return
	call_phase(turn_order[turn_pos])

func start_player_turn():
	turn_pos = 0
	gameactions_label.text = 'Your turn, playboy.'

func end_round() -> bool:
	for x in results_dict.keys():
		results_dict[x].clear()
	last_quantity = 0
	last_face = 0
	turn_pos = 0
	return true

#bid information & management-----------------
func _set_bid(amount: int, face: int, bidder := "player") -> bool:
	print( bidder+" bid is: "+str(amount) +" "+str(face)+"s")
	last_quantity = amount
	last_face = face
	last_bidder = bidder
	if turn_pos == 0:
		next_turn()
	return true

func set_last_quantity(current) -> void: #note: potentially shift bids to a dictionary revolving around npcs
	last_quantity = current

func set_last_face(current) -> void:
	last_face = current

func get_npc_bid():
	#TODO: insert literally any npc betting logic here
	var quantity : int = last_quantity
	var face : int = last_face
	
	if face == 6 : # if it's already 6, incremener quantity a random amount.
		quantity = quantity+randi_range(1,4)
		return [quantity,face]
	
	if randi_range(1, 10) <= 5: # flip a coin and increment either quantity or face
		quantity = last_quantity+1
		return [quantity,face]
	else:
		face = last_face+1
	return [quantity,face]

#determining dice values --------
func set_dice_value( dice_value_array : Array, target: = "player") -> void:
	var target_dict = results_dict[target]
	if !dice_value_array:
		push_error("Error: set_dice was called in player_die but no value was passed through.")
	if target_dict.size() >= handsize_dict[target]:
		push_error("Error: Attempting to add values to a hand when the hand is full.")
		return
	results_dict[target] = dice_value_array

func set_npc_dice(npc) -> void:
	if !npc:
		push_error("Error: set_npc_dice was called but there was no parameter for npc variable.")
	var roll : int = 0
	var curr_rolls := []
	
	for x in handsize_dict[npc]:
		roll = randi_range(1,6)
		curr_rolls.append(roll)
	
	set_dice_value(curr_rolls,npc)

func get_player_value() -> void:
	var dice_array = %"Player Dice".get_children()
	
	if dice_array == []:
		push_error("Error: You tried to check the value of the player's dice but the dice haven't been rolled yet.")
		return
	
	results_dict["player"].clear()
	
	var curr_roll : Array
	for die in %"Player Dice".get_children():
		if die.visible == true:
			curr_roll.append(die.dice_value)
	
	set_dice_value(curr_roll)


#game functions ------------------
func declare_game_state():
	var game_state_string = ""
	for property_info in self.get_script().get_script_property_list():
		var var_name = property_info.name
		var var_value = self.get(var_name)
		var curr_prop = str(var_name) + " = " + str(var_value)
		game_state_string = game_state_string + "\n" + curr_prop
	return game_state_string
	
func resolve_challenge(chal :="player") -> bool: 
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
	
	await get_tree().create_timer(6.0).timeout #wait some time then display all the information
	
	
	var a = str(name_conversion[chal]) + " made the challenge.\n"
	var b = str(name_conversion[last_bidder]) + "made the bid.\n"
	var c = "Current bid is: " +str(last_quantity)+" "+dice_conversion_dict[last_face]+"\n"
	var d = "There are currently "+ str(filtered_final_pool.size())+" "+dice_conversion_dict[last_face]+"\n \n"
	var e = str(name_conversion[round_result])+" wins the challenge.\n"
	var f : String
	
	if round_result == last_bidder:
		f = str(name_conversion[chal])+" will lose a dice. We keep it moving."
	else:
		f =  str(name_conversion[last_bidder])+" will lose a dice. We keep it moving."
	
	var conclusion = [a,b,c,d,e,f]
	gameactions_label.text = "".join(conclusion)
	
	await get_tree().create_timer(60.0).timeout #display all the information
	
	handsize_dict[round_result] = handsize_dict[round_result] - 1 #reduces the losing player's handsize by one hand sizes
	
	await end_round()
	return true
