extends Control

@onready var chkval_btn : Button = $debugfunctions/check_value
@onready var roll_npc1 : Button = $debugfunctions/roll_npc1
@onready var roll_npc2 : Button = $debugfunctions/roll_npc2
@onready var roll_npc3 : Button = $debugfunctions/roll_npc3
@onready var declare_gamestate : Button = $debugfunctions/declare_gamestate
@onready var start_round : Button = $debugfunctions/start_round
@onready var resolve_challenge : Button = $debugfunctions/resolve_challenge

func _ready() -> void:
	chkval_btn.pressed.connect(_check_value)
	roll_npc1.pressed.connect(_roll_npc1_dice)
	roll_npc2.pressed.connect(_roll_npc2_dice)
	roll_npc3.pressed.connect(_roll_npc3_dice)
	declare_gamestate.pressed.connect(_declare_gamestate)
	start_round.pressed.connect(_start_game)
	resolve_challenge.pressed.connect(_resolve_challenge)
	pass

func _check_value():
	%PublicInformation.get_player_value()

func _roll_npc1_dice():
	%PublicInformation.set_npc_dice("npc1")

func _roll_npc2_dice():
	%PublicInformation.set_npc_dice("npc2")

func _roll_npc3_dice():
	%PublicInformation.set_npc_dice("npc3")

func _declare_gamestate():
	var info = %PublicInformation.declare_game_state()
	$gameinformation.text = info

func _start_game():
	%PublicInformation.start_round()

func _resolve_challenge():
	%PublicInformation.resolve_challenge()

func _on_start():
	self.visible = true
