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
		["npc1" , "Alright. Call." , 3.0 , "Nuetral", "Idle"],
	],
	"npc2_call" : [
		["npc2" , "Why not?" , 1.5 , "Nuetral", "Idle"],
		["npc2" , "Call!" , 1.5 , "Attention", "Idle"],
	],
	"npc3_call" : [
		["npc2" , "Wait..." , 1.0 , "Angry", "Thinky"],
		["npc2" , "Oh!" , 1.0 , "Surprised", "Thinky"],
		["npc2" , "Call!" , 3.0 , "Evil", "Attention"]
	],
	"npc1_think" : [
		["npc1" , "Let's see..." , 3.0 , "Nuetral", "Thinky"],
	],
	"npc2_think" : [
		["npc2" , "Hmmmm..." , 3.0 , "Nuetral", "Thinky"],
	],
}

func set_dialogue(event : String ):
	print("Event is: ",event)
	
	var dialogue
	
	if dialogue_dict.has(event):
		 #NOTE from J: this first checks if that specific event exists. if its does, play that.
		dialogue = dialogue_dict[event]
	else:
		#NOTE from J: otherwise, it's a generic and can be handled by the generic handled
		dialogue = get_generic_dialogue(event)
	
	print("Dialogue after block is: ",dialogue)
	
	Globals.speak.emit(dialogue)
	await Globals.speak_finished
	
	return true

func get_generic_dialogue(event : String) -> Array:
	#NOTE from J: parameters for readability
	var speaker
	var dialogue
	var time
	var expression
	var anim
	
	
	if event.contains('pass'): #handles passes
		speaker = event.split("_")[0]
		dialogue = "I will pass"
		time = 3.0
		expression = "Nuetral"
		anim = "SmallTalk"
	elif event == 'npc3_think':
		#NOTE from J: handles vickie's random thinking
		var thoughts = ['Oh' , 'Um...', 'Erm...', 'What if...', 'Oh no.']
		var feelings = ["Evil","Thinky","Thinky","Evil","Surprised"]
		
		speaker = "npc3"
		dialogue = thoughts[randi_range(1, thoughts.size()-1)]
		time = 3.0
		expression = feelings[randi_range(1, feelings.size()-1)]
		anim = "Thinky"
	
	return [ [speaker, dialogue, time, expression, anim] ]
