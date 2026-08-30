extends Node

@onready var bettingbot : Node = %"Betting Bot"
@onready var gameactions_label : Node = %"gameactions"
@onready var allbets_label : Node = %"allbets"
@onready var playmat : Node = %"Playmat"
@onready var main : Node = get_parent()
@onready var last_quantity = Globals.last_quantity
@onready var last_face = Globals.last_face
@onready var npcscreens = %'NPC Screens'

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
	"player" : "You",
	"npc1" : "Slade",
	"npc2" : "Boone",
	"npc3" : "Vickie"
}

const num_conversion = {
	1 : 'One',
	2 : 'Two',
	3 : 'Three',
	4 : 'Four',
	5 : 'Five',
	6 : 'Six',
}

const sinister_phrases = [
	"Lucky you.",
	"Trusting bunch.",
	"But [shake]why?[shake]",
	"Have they forgiven?",
	"Could life be so sweet?",
	"They might remember the good times."
]

const start_of_turn_phrases = [
	"You're up, playboy.",
	"Let's try hard this time.",
	"Tricked them then, too.",
	"Do you think they trust you?",
	"Back up to bat."
]

var last_bidder : String = "player" #last_quantity, last_face are declared in on ready and are linked to the global property
var challenger : String

var turn_pos : int = 0
var turn_order = ["player", "npc1", "npc2", "npc3"]
var char_name = ["Major","Slade","Boone","Vickie"]
var removed_players : Array = []
var remaining_players : int = 4

var final_pool : Array = []
var filtered_final_pool : Array = []
var call_pressed :bool = false

signal timer_start
signal player_removed

func _ready() -> void:
	bettingbot.lock_bet.connect(_set_bid)
	pass

#turn management-------------------
func start_round() -> void:
	if results_dict["player" ] == []:
		get_player_value()
	for x in results_dict.keys(): #roll the dice for npcs
		if x == "player":
			continue
		set_npc_dice(x)
	next_turn()

func bid_phase(curr_character) -> bool:
	var char_string = name_conversion[curr_character]
	
	await Dialogue.set_dialogue(curr_character+"_bidthink")
	gameactions_label.text = str(char_string)+"'s turn. [shake]Thinking...[shake]"
	
	var curr_bid : Array = get_npc_bid(curr_character)
	gameactions_label.text = str(char_string)+" bids." # allbets label is set in the set_bid function
	_set_bid(curr_bid[0],curr_bid[1],curr_character)
	
	await get_tree().create_timer(3.0).timeout
	call_phase(curr_character)
	return true

func call_phase(curr_character : String) -> bool:
	var decision = await decision_process(curr_character) #true is bid, false is call
	if decision == false:
		if call_pressed == true:
			challenger = 'player'
		
		gameactions_label.text = "[shake][color=crimson]"+str(name_conversion[challenger])+"[color=crimson] called.[shake]"
		npcscreens.sort_npc_screen_update(challenger, 'call')
		
		if challenger != 'player':
			await Dialogue.set_dialogue(challenger +"_call")
		await resolve_challenge(challenger)
		
	if decision == true:
		gameactions_label.text = "No one calls.\n"+sinister_phrases[randi_range(0,sinister_phrases.size()-1)]
		turn_pos = turn_pos+1
		next_turn()
	return true

func decision_process( curr_character ) -> bool:
	var determined_decision = true
	for deciding_char in turn_order:
		if deciding_char == curr_character:
			continue
		determined_decision = await determine_call_or_pass(deciding_char, name_conversion[deciding_char]) #true for bet, false for pass
		playmat.set_buttons("BOTH",false)
		if determined_decision == false:
			challenger = deciding_char
			return false
		gameactions_label.text = name_conversion[deciding_char] +" will [color=green]pass.[color=green]"
		if deciding_char != 'player':
			print('Deciding char is: ',deciding_char)
			await Dialogue.set_dialogue(deciding_char+"_pass")
			await get_tree().create_timer(3.0).timeout
	return true

func next_turn():
	if turn_pos == 0:
		call_phase(turn_order[turn_pos])
		return
	if turn_pos == turn_order.size():
		start_player_turn()
		return
	bid_phase( turn_order[turn_pos] )

func start_player_turn():
	await Dialogue.set_dialogue('reset')
	if turn_pos == 4:
		playmat.set_buttons("BET",true)
	else:
		playmat.set_buttons("BET",false)
	turn_pos = 0

	update_global_minimum()

func end_round() -> bool:
	await remove_player()
	turn_pos = 0
	for x in results_dict.keys():
		results_dict[x].clear()
	
	challenger = ""
	call_pressed = false
	last_quantity = 0
	last_face = 0
	update_global_minimum()
	
	gameactions_label.text = start_of_turn_phrases[randi_range(0, start_of_turn_phrases.size()-1)]
	allbets_label.text = ""
	
	await Dialogue.set_dialogue('reset')
	get_parent().reset()
	
	return true

#bid information & management-----------------
func _set_bid(amount: int, face: int, bidder := "player") -> bool:
	last_quantity = amount
	last_face = face
	last_bidder = bidder
	allbets_label.text = str(name_conversion[bidder])+" bid "+str(last_quantity)+" "+str(num_conversion[last_face])+"(s) \n" + allbets_label.text
	update_global_minimum()
	
	if bidder != 'player':
		npcscreens.sort_npc_screen_update(bidder,'bet')
		await Dialogue.set_dialogue(bidder+'_bid')
	
	if turn_pos == 0:
		start_round()
	return true

func set_last_quantity(current) -> void: #note: potentially shift bids to a dictionary revolving around npcs
	last_quantity = current

func set_last_face(current) -> void:
	last_face = current

func get_npc_bid(npc) -> Array[int]:
	var quantity : int = last_quantity
	var face : int = last_face
	
	var hand = results_dict[npc]
	#check if you have the current number of the current quantity is in your hand
	# if yes, increment to that number
	if hand.filter( func(number): return number == last_face).size() > last_quantity:
		print('same quantity function')
		return [hand.filter( func(number): return number == last_face) , face]
	if face >= 6 : # if it's already 6, incremener quantity a random amount. [note from z: always use greater than to clamp an amount, otherwise overshoots can cause errors]
		quantity = quantity+randi_range(1,3)
		return [quantity,face]
	if randi_range(1, 10) <= 5: # flip a coin and increment either quantity or face
		quantity = last_quantity+randi_range(1,3)
		return [quantity,face]
	else:
		face = last_face+randi_range(1,3)
		if face > 6:		#note from z: this needed to be clamped. It was possible for this to return face values over 6
			face = 6
	return [quantity,face]

#determining dice values --------
func set_dice_value( dice_value_array : Array, target: = "player") -> void:
	var target_dict = results_dict[target]
	if handsize_dict[target] == 0: #target has no dice left
		return
	if !dice_value_array:
		push_error("Error: set_dice was called in player_die but no value was passed through.")
	if target_dict.size() >= handsize_dict[target]:
		push_error("Error: Attempting to add values to "+str(target)+" hand when the hand is full.")
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

func remove_player() -> bool:
	for curr_character in turn_order:
		if handsize_dict[curr_character] == 0:
			turn_order.erase(curr_character)
			gameactions_label.text = name_conversion[curr_character]+" has been removed from the game."
			await Dialogue.set_dialogue(curr_character+"_out")
			npcscreens.sort_npc_screen_update(curr_character, "out")
			player_removed.emit(char)
	return true

func declare_game_state():
	var game_state_string = ""
	for property_info in self.get_script().get_script_property_list():
		var var_name = property_info.name
		var var_value = self.get(var_name)
		var curr_prop = str(var_name) + " = " + str(var_value)
		game_state_string = game_state_string + "\n" + curr_prop
	return game_state_string

func determine_call_or_pass(deciding_char,char_string) -> bool: #true means bid, false means call
	if deciding_char == 'player':
		gameactions_label.text = "Your decision. [shake][color=red]Call?[color=red][shake]"
		playmat.set_buttons("CALL",true)
		await get_tree().create_timer(3.0).timeout
		playmat.set_buttons("CALL", false)
		if call_pressed == true:
			return false
		return true
	
	gameactions_label.text =  str(char_string)+"'s decision..."
	npcscreens.sort_npc_screen_update(deciding_char,'think')
	await Dialogue.set_dialogue(deciding_char + "_think")
	
	var hand = results_dict[deciding_char]
	if last_quantity >= 20:
		return false
		#will call you if you max bet or higher
	if last_quantity >= 10 and randi_range(1,10) >= 2:
		return false
		#if over 10, very likely to call you
	if hand.filter( func(number): return number == last_face).size() >= last_quantity:
		return true
		# if you bid more of a face than they have in hand, they bid as you will always win challenge
	if randi_range(1,100) <= 10:
		return false
		#random chance to call
	return true

func update_global_minimum() -> void:
	Globals.last_quantity = last_quantity
	Globals.last_face = last_face

func set_call_pressed(press : bool):
	call_pressed = press

func resolve_challenge(chal :="player") -> bool: 
	var loser : String
	var winner : String
	
	final_pool.clear()
	
	for keys in results_dict.keys():
		for val in results_dict[keys]:
			final_pool.append(val)
	filtered_final_pool = final_pool.filter( func(number): return number == last_face)
	
	if last_quantity <= filtered_final_pool.size(): #if the last bid was equal to or less than the final pool
		loser = chal
		winner = last_bidder
	else:
		loser = last_bidder
		winner = chal
	
	var a = str(name_conversion[chal]) + " made the challenge.\n"
	var b = str(name_conversion[last_bidder]) + " made the bid.\n \n"
	var c = "Current bid: [color=green]" +str(last_quantity)+" "+num_conversion[last_face]+"(s)[/color]\n"
	var d = "Pool has: [color=green]"+ str(filtered_final_pool.size())+" "+num_conversion[last_face]+"(s)[/color]\n"
	if winner == chal:
		d = "Pool has: [color=red]"+ str(filtered_final_pool.size())+" "+num_conversion[last_face]+"(s)[/color]\n \n"
	var e = str(name_conversion[winner])+" wins the challenge.\n"
	if str(name_conversion[winner]) ==  "You":
		e = str(name_conversion[winner])+" won the challenge.\n"
	var f : String
	
	var conclusion = [a,b,c,d,f,e]
	gameactions_label.text = e
	allbets_label.text = "".join(conclusion)
	
	if winner != 'player':
		await Dialogue.set_dialogue(winner+"_win")
	
	handsize_dict[loser] = handsize_dict[loser] - 1 #reduces the losing player's handsize by one hand sizes
	npcscreens.sort_npc_screen_update(loser, "dice_update", handsize_dict[loser])
	
	await get_tree().create_timer(6.0).timeout #display all the information
	
	gameactions_label.text = str(name_conversion[loser])+" loses a dice.\nThey have "+str(handsize_dict[loser])+" left."
	
	if loser != 'player':
		await Dialogue.set_dialogue(loser+"_lose")
	
	
	end_round()
	return true
