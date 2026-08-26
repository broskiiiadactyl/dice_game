extends Control

@onready var chkval_btn : Button = $check_value
@onready var roll_npc : Button = $roll_npc_dice

func _ready() -> void:
	chkval_btn.pressed.connect(_check_value)
	roll_npc.pressed.connect(_roll_npc_dice)
	pass

func _check_value():
	print('this is a test!')

func _roll_npc_dice():
	print('Roll NPC Button pressed')
	PublicInformation.determine_npc_dice("npc1")
