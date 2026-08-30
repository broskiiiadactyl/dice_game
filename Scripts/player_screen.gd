extends Node3D

@onready var bet : Control = %Bet
@onready var wait : Control = %wait
@onready var one : Control = %"1"
@onready var two : Control = %"2"
@onready var three : Control = %"3"
@onready var bet_num : Control = %"Bet Num"
@onready var bet_face : Control = %"Bet Face"

var num_of_dice : int
var is_calling : bool = false
var is_passing : bool = false
var is_out : bool = false

@onready var faces : Array[CompressedTexture2D] = [
	load("res://Assets/theme styling/die1.png"),
	load("res://Assets/theme styling/die2.png"),
	load("res://Assets/theme styling/die3.png"),
	load("res://Assets/theme styling/die4.png"),
	load("res://Assets/theme styling/die5.png"),
	load("res://Assets/theme styling/die6.png")
]

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	update_screen()

func update_screen() -> void:
	while true:
		await get_tree().create_timer(1.0).timeout
		if Globals.last_face >= 1:
			bet_num.text = str(Globals.last_quantity)
			bet_face.texture = faces[Globals.last_face - 1]
			bet.visible = true
			wait.visible = false
		else:
			bet.visible = false
			wait.visible = true
			
			one.visible = true
			await get_tree().create_timer(0.5).timeout
			two.visible = true
			await get_tree().create_timer(0.5).timeout
			three.visible = true
			await get_tree().create_timer(0.5).timeout
			one.visible = false
			two.visible = false
			three.visible = false
