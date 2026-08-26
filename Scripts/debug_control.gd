extends Control

@onready var chkval_btn : Button = $check_value
@onready var roll_npc1 : Button = $roll_npc1
@onready var roll_npc2 : Button = $roll_npc2
@onready var roll_npc3 : Button = $roll_npc3

func _ready() -> void:
	chkval_btn.pressed.connect(_check_value)
	roll_npc1.pressed.connect(_roll_npc1_dice)
	roll_npc2.pressed.connect(_roll_npc2_dice)
	roll_npc3.pressed.connect(_roll_npc3_dice)
	pass

func _check_value():
	print('this is a test!')

func _roll_npc1_dice():
	%PublicInformation.determine_npc_dice("npc1")

func _roll_npc2_dice():
	%PublicInformation.determine_npc_dice("npc2")

func _roll_npc3_dice():
	%PublicInformation.determine_npc_dice("npc3")
