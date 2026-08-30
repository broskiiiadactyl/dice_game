extends Node3D

@onready var bet : Control = %Bet
@onready var wait_roll : Control = %"wait roll"
@onready var one : Control = %"1"
@onready var two : Control = %"2"
@onready var three : Control = %"3"
@onready var bet_num : Control = %"Bet Num"
@onready var bet_face : Control = %"Bet Face"
@onready var wait_bet : Control = %"wait bet"
@onready var down1 : Control = %down1
@onready var down2 : Control = %down2
@onready var wait_call : Control = %"wait call"
@onready var cd : Control = %Countdown

var num_of_dice : int
var is_roll : bool = false
var is_bet : bool = false
var is_call : bool = false

@onready var faces : Array[CompressedTexture2D] = [
	load("res://Assets/theme styling/die1.png"),
	load("res://Assets/theme styling/die2.png"),
	load("res://Assets/theme styling/die3.png"),
	load("res://Assets/theme styling/die4.png"),
	load("res://Assets/theme styling/die5.png"),
	load("res://Assets/theme styling/die6.png")
]

func _ready() -> void:
	update_screen()

func update_screen() -> void:
	while true:
		if is_bet:
			bet.visible = false
			wait_roll.visible = false
			wait_bet.visible = true
			wait_call.visible = false
			
			down1.visible = true
			down2.visible = true
			await get_tree().create_timer(0.5).timeout
			down1.visible = false
			down2.visible = false
			await get_tree().create_timer(0.5).timeout
			down1.visible = true
			down2.visible = true
			await get_tree().create_timer(0.5).timeout
			down1.visible = false
			down2.visible = false
		elif is_roll:
			bet.visible = false
			wait_roll.visible = true
			wait_bet.visible = false
			wait_call.visible = false
			
			one.visible = true
			await get_tree().create_timer(0.5).timeout
			two.visible = true
			await get_tree().create_timer(0.5).timeout
			three.visible = true
			await get_tree().create_timer(0.5).timeout
			one.visible = false
			two.visible = false
			three.visible = false
		elif is_call:
			bet.visible = false
			wait_roll.visible = false
			wait_bet.visible = false
			wait_call.visible = true
			
			cd.text = str(3)
			await get_tree().create_timer(1.0).timeout
			cd.text = str(2)
			await get_tree().create_timer(1.0).timeout
			cd.text = str(1)
			await get_tree().create_timer(1.0).timeout
			cd.text = str(0)
			await get_tree().create_timer(1.0).timeout
			cd.visible = false
		else:
			bet_num.text = str(Globals.last_quantity)
			bet_face.texture = faces[Globals.last_face - 1]
			bet.visible = true
			wait_roll.visible = false
			wait_bet.visible = false
			wait_call.visible = false
			await get_tree().create_timer(1.0).timeout

func normal() -> void:
	is_roll = false
	is_bet = false
	is_call = false

func waiting_for_bet() ->void:
	is_roll = false
	is_bet = true
	is_call = false

func waiting_for_roll()-> void:
	is_roll = true
	is_bet = false
	is_call = false

func waiting_for_call() -> void:
	is_roll = false
	is_bet = false
	is_call = true
