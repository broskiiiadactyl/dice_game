extends Node

var name_conversion_dict = {
	"player" :"Major",
	"npc1" : "Slade",
	"npc2" : "Boone",
	"npc3" : "Vickie"
}
var dialogue_dict = { #character, dialogue, time, expression, anim
	#charactercall
	"npc1_call" : [
		["npc1" , "Alright. Call." , 0.5, "Nuetral", "idle"],
	],
	"npc2_calls" : [
		["npc2" , "Why not? I'll call." , 0.5, "sad", "idle"],
	],
	"npc3_calls" : get_vickie_call()
}

func set_dialogue(event : String ):
	var dialogue
	
	if dialogue_dict.has(event):
		dialogue = dialogue_dict[event]
	else:
		dialogue = get_generic_dialogue(event)
	
	#push_error('Globals is commented out.')
	Globals.speak.emit(dialogue)
	await Globals.speak_finished
	
	return true

func get_generic_dialogue(event : String) -> Array:
	
	if event.contains('pass'): #handles passes
		return [ [event.split("_")[0] , "Pass" , 0.5, "Nuetral", "idle"] ]
	
	return []

func get_vickie_call(): #TODO: Randomize the Vickie Calls
	var words : String = "Call"
	var time : float = 0.0
	var exp : String = "Nuetral"
	var anim : String = "Idle"
	
	return ["npc3", words, time, exp, anim ]
