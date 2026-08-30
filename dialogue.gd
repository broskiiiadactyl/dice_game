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
		["npc3" , "Wait..." , 1.0 , "Angry", "Thinky"],
		["npc3" , "Oh!" , 1.0 , "Surprised", "Thinky"],
		["npc3" , "Call!" , 3.0 , "Evil", "Attention"]
	],
	"npc1_think" : [
		["npc1" , "Let's see..." , 1.5 , "Nuetral", "Thinky"],
	],
	"npc2_think" : [
		["npc2" , "Hmmmm..." , 1.5  , "Nuetral", "Thinky"],
	],
	"npc1_bidthink" : [
		["npc1" , "My turn, huh?" , 3.0 , "Nuetral", "Thinky"],
	],
	"npc2_bidthink" : [
		["npc2" , "How does this go again..." , 3.0 , "Nuetral", "Thinky"],
	],
	"npc3_bidthink" : [
		["npc3" , "Uhh..." , 1.0 , "Nuetral", "Thinky"],
		["npc3" , "Okay!" , 1.0 , "Surprised", "Idle"],
		["npc3" , "I know what to bid!" , 1.0 , "Evil", "Idle"],
	],
	"npc1_win" : [
		["npc1" , "I won. Simple as that." , 6.0 , "Nuetral", "Win"],
	],
	"npc2_win" : [
		["npc2" , "I win? Would you look at that." , 6.0 , "Nuetral", "Win"],
	],
	"npc3_win" : [
		["npc3" , "Oh! I won! I won!" , 6.0 , "Neutral", "Win"],
	],
	"npc1_lose" : [
		["npc1" , "Wh-" , 0.5, "Surprised", "Idle"],
		["npc1" , "Here's what I think of that." , 3.0, "Nuetral", "Lose"]
	],
	"npc2_lose" : [
		["npc2" , "Oh I lost? That's how it goes." , 3.0 , "Nuetral", "Lose"],
	],
	"npc3_lose" : [
		["npc3" , "Losing is way less fun." , 3.0 , "Neutral", "Lose"],
	],
	"reset" : [
		["npc1" , "" , 0.5 , "Nuetral", "Idle"],
		["npc2" , "" , 0.5 , "Nuetral", "Idle"],
		["npc3" , "" , 0.5 , "Nuetral", "Idle"],
	],
	"npc1_out" : [
		["npc1" , "I'm out?" , 2.0 , "Nuetral", "Idle"],
		["npc1" , "I'm out? genuinely can't believe it." , 2.0 , "Nuetral", "Idle"],
	],
	"npc2_out" : [
		["npc2" , "Ah, well. It was a wonderful time regardless." , 3.0 , "Nuetral", "Idle"],
	],
	"npc3_out" : [
		["npc3" , "Catch me in my ship next time." , 3.0 , "Neutral", "Idle"],
		["npc3" , "We'll see how it goes then." , 3.0 , "Neutral", "Idle"]
	],
	"npc1_shake" : [
		["npc1" , "" , 3.0 , "DiceShake", "DiceShake"],
	],
	"npc2_shake" : [
		["npc2" , "" , 3.0 , "DiceShake", "DiceShake"],
	],
	"npc3_shake" : [
		["npc3" , "" , 3.0 , "DiceShake", "DiceShake"],
	],
	"npc1_pass" : [
		["npc1" , "Well..." , 1.5 , "Angry", "Idle"],
		["npc1" , "Seems right." , 1.5 , "Nuetral", "Idle"],
	],
	"npc2_pass" : [
		["npc2" , "No challenge from me!" , 3.0 , "Nuetral", "Idle"],
	],
	"npc3_pass" : [
		["npc3" , "I think you're being honest!" , 3.0 , "Nuetral", "Idle"],
	],
	"0" : [
		["npc2", "Commander! You made it!", 2.0, "Nuetral", "Idle"],
		["npc3", "Not Commander for long...", 0.5, "Nuetral", "Idle"],
		["npc2", "I'm so glad you could join us here for a round of Liar's Dice!", 3.0, "Nuetral", "Idle"],
		["npc1", "Well... Imperial Dice.", 1.0, "Nuetral", "Idle"],
		["npc1", "The rules are wrong.", 2.0, "Nuetral", "Idle"],
		["npc2", "Yes. No wilds and...", 2.0, "Nuetral", "Idle"],
		["npc3", "Everyone gets a chance to call!", 3.0, "Nuetral", "Idle"],
		["npc2", "Precisely. Keeps the game more fun. This way you...", 2.0, "Nuetral", "Idle"],
		["npc1", "Can't trust anyone.", 3.0, "Nuetral", "Idle"],
		["player", "...", 3.0, "Nuetral", "Idle"],
		["npc2", "Yes, well. Let's get to it shall we?", 3.0, "Nuetral", "Idle"],
		["npc3", "Liar's dice, woohoo!", 1.0, "Nuetral", "Idle"]
	],
	"win" : [
		["npc1", "Damn.", 1.0, "Neutral", "Idle"],
		["npc3", "Beginner's luck", 0.5, "Angry", "Idle"],
		["npc2", "Never comes down to luck with the commander.", 3.0, "Neutral", "Idle"],
		["npc1", "Classic.", 1.0, "Neutral", "Idle"],
		["npc2", "It makes what comes next...", 3.0, "Neutral", "Idle"],
		["npc2", "All the harder.", 3.0, "Neutral", "Idle"],
		["npc3", "", 0.5, "Sad", "Idle"],
		["npc1", "I tried to fight this.", 3.0, "Neutral", "Idle"],
		["npc1", "But it's the right call", 3.0, "Neutral", "Idle"],
		["npc2", "The Empite thanks you for your past service.", 3.0, "Neutral", "Idle"],
		["npc2", "Goodbye, Commander.", 3.0, "Neutral", "Idle"]
	],
	"lose" : [
		["npc1", "You lose.", 1.0, "Neutral", "Idle"],
	]
}

var round_key = 0

func increment_round_key():
	round_key += 1
	return round_key

func check_for_cutscene(chk_value):
	return dialogue_dict.has(chk_value)

func set_dialogue(event : String ):
	#print("Event is: ",event)
	
	var dialogue
	
	if dialogue_dict.has(event):
		 #NOTE from J: this first checks if that specific event exists. if its does, play that.
		dialogue = dialogue_dict[event]
	else:
		#NOTE from J: otherwise, it's a generic and can be handled by the generic handled
		#NOTE from J: anytime i have to handle the dialogue inclduing randomness it ends u phere
		dialogue = get_generic_dialogue(event)
	
	#print("Dialogue after block is: ",dialogue)
	
	Globals.speak.emit(dialogue)
	await Globals.speak_finished
	
	return true

func get_generic_dialogue(event : String) -> Array:
	#NOTE from J: parameters for readabilityw
	var speaker
	var dialogue
	var time = 3.0
	var expression = "Nuetral"
	var anim = "Idle"
	
	
	if event.contains('_bid'):
		speaker = event.split("_")[0]
		dialogue = "I bid "+str(Globals.last_quantity)+" "+Globals.num_conversion[Globals.last_face]+"(s)"
		time = 3.0
		expression = "Nuetral"
		anim = "Attention"
		pass
	elif event == 'npc3_think':
		#NOTE from J: handles vickie's random thinking
		var thoughts = ['Oh' , 'Um...', 'Erm...', 'What if...', 'Oh no.']
		var feelings = ["Evil","Thinky","Thinky","Evil","Surprised"]
		
		speaker = "npc3"
		dialogue = thoughts[randi_range(1, thoughts.size()-1)]
		time = 1.5
		expression = feelings[randi_range(1, feelings.size()-1)]
		anim = "Idle"
	
	return [ [speaker, dialogue, time, expression, anim] ]
