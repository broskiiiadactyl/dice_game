extends Node

var results_dict = {
	"player" : [],
	"npc1" : [],
	"npc2" : [],
	"npc3" : []
}

func _ready():
	pass

func set_dice( dice_value, target: = "player"):
	if !dice_value:
		push_error("Error: set_dice was called in player_die but no value was passed through.")
	
	results_dict[target].append(dice_value)
	
	# dict[key].clear() to remove values from an array
	print( str(dice_value)+" adds to "+target+"'s result dictionary")
