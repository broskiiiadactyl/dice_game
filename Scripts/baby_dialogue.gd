extends CanvasLayer

@onready var slade : RichTextLabel = %SladeTalk
@onready var boone : RichTextLabel = %BooneTalk
@onready var vickie : RichTextLabel = %VickieTalk
@onready var player : RichTextLabel = %PlayerTalk

@onready var speaker : RichTextLabel = %PlayerTalk

func _ready() -> void:
	Globals.speak.connect(translate_array)

func translate_array(args: Array)->void:
	for line in args:
		await speak(line[0],line[1],line[2],line[3],line[4])
	Globals.speak_finished.emit()

func speak(character: String = "player", dialogue: String = "", time: float = 5.0, expression: String = "Neutral", anim: String = "Idle") -> bool:
	match character:
		"player":
			speaker = player
		"npc1":
			speaker = slade
		"npc2":
			speaker = boone
		"npc3":
			speaker = vickie
		_:
			push_error("Invalid character set for dialogue: ", character)
	
	while speaker.is_talking:
		await get_tree().create_timer(0.1).timeout
	
	await speaker.speak(dialogue, time, expression, anim)
	
	return true
