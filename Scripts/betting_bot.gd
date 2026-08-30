extends Node3D

@onready var bet_label : RichTextLabel = %"Bet Label"
@onready var dice_label : RichTextLabel = %"Dice Label"
@onready var sv : SubViewport = %SubViewport
@onready var screen : MeshInstance3D = %MeshInstance3D

@onready var anim_player : AnimationPlayer = %AnimationPlayer
@onready var text_display : Control = %CenterContainer

@onready var whir : AudioStreamPlayer3D = %Whir
@onready var button : AudioStreamPlayer3D = %Button
@onready var whir_sfx : AudioStreamWAV = load("res://Assets/Sounds/robot_whir_2.wav")
@onready var submit_button : AudioStreamPlayer3D = %"Submit Button"

var num_bet : int = 1
var dice_bet : int = 1
var max_bet : int = 20
var dice_max : int = 6

var min_num_bet = 1
var min_face_bet = 1

var can_take_input : bool = true

#for managing button appearances
@onready var bup : Button = %"Bet Up"
@onready var bdown : Button = %"Bet Down"
@onready var dup : Button = %"Dice Up"
@onready var ddown : Button = %"Dice Down"
@onready var face_label : TextureRect = %"Dice Faces"
@onready var submit : Button = %Submit

@onready var face_images : Array[CompressedTexture2D] = [
	load("res://Assets/theme styling/die1.png"),
	load("res://Assets/theme styling/die2.png"),
	load("res://Assets/theme styling/die3.png"),
	load("res://Assets/theme styling/die4.png"),
	load("res://Assets/theme styling/die5.png"),
	load("res://Assets/theme styling/die6.png")
]

signal lock_bet(amount: int, face: int)

func _on_bet_up_pressed() -> void:
	set_num_bet(1)
	await get_tree().create_timer(0.1).timeout
	bup.release_focus()

func _on_bet_down_pressed() -> void:
	set_num_bet(-1)
	await get_tree().create_timer(0.1).timeout
	bdown.release_focus()

func _on_dice_up_pressed() -> void:
	set_dice_bet(1)
	await get_tree().create_timer(0.1).timeout
	dup.release_focus()

func _on_dice_down_pressed() -> void:
	set_dice_bet(-1)
	await get_tree().create_timer(0.1).timeout
	ddown.release_focus()


#SENDS SIGNAL "lock_bet" with the currently entered bets
func _on_submit_pressed() -> void:
	if num_bet <= 1:
		num_bet = 1
	if dice_bet <= 1:
		dice_bet = 1
	if num_bet == min_num_bet and dice_bet == min_face_bet and num_bet != 1:
		wrong()
		return
	$Area3D.process_mode = Node.PROCESS_MODE_DISABLED
	submit_button.play()
	can_take_input = false
	await get_tree().create_timer(0.1).timeout
	submit.release_focus()
	lock_bet.emit(num_bet, dice_bet)
	await enter_anim()
	text_display.visible = false
	%CenterContainer2.visible = true
	%Check.animate()
	await get_tree().create_timer(1.0).timeout
	play_anim(1)

func set_num_bet(dir: int) -> void:
	button.play()
	var new_bet : int = num_bet + dir
	if not dice_bet > min_face_bet:
		if new_bet < min_num_bet:
			num_bet = min_num_bet
			return
	elif new_bet > max_bet or new_bet < 1:
			return
	num_bet = new_bet
	bet_label.text = str(num_bet) 

func set_dice_bet(dir: int) ->void:
	button.play()
	var new_bet : int = dice_bet + dir
	if new_bet < min_face_bet or new_bet > dice_max:
		return
	if new_bet >= min_face_bet and num_bet < min_num_bet:
		num_bet = min_num_bet
		bet_label.text = str(num_bet)
	dice_bet = new_bet
	face_label.texture = face_images[dice_bet - 1]

func enter() -> void:
	num_bet = 0
	dice_bet = 0
	if Globals.last_quantity:
		min_num_bet = Globals.last_quantity
	else:
		min_num_bet = 1
	if Globals.last_face:
		min_face_bet = Globals.last_face
	else:
		min_face_bet = 1
	
	set_num_bet(min_num_bet - 1)
	set_dice_bet(min_face_bet - 1)
	
	%CenterContainer2.visible = false
	$Area3D.process_mode = Node.PROCESS_MODE_INHERIT
	await play_anim(0)
	text_display.visible = true
	can_take_input = true


func _on_area_3d_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("LMB") and can_take_input:
		var translated_event: InputEvent = InputEventMouseButton.new()
		translated_event.button_index = 1
		translated_event.pressed = true
		
		var translated_mouse_pos : Vector3 = screen.global_transform.affine_inverse() * event_position
		
		var mouse_pos_2D : Vector2 = Vector2(translated_mouse_pos.x, -translated_mouse_pos.y)
		
		mouse_pos_2D.x = mouse_pos_2D.x / screen.mesh.size.x
		mouse_pos_2D.y = mouse_pos_2D.y / screen.mesh.size.y
		
		mouse_pos_2D.x += 0.5
		mouse_pos_2D.y += 0.5
		
		mouse_pos_2D.x *= sv.size.x
		mouse_pos_2D.y *= sv.size.y
		
		translated_event.position = mouse_pos_2D
		
		sv.push_input(translated_event)

func play_anim(dir: bool) -> bool:
	if dir:
		anim_player.play("Move Out")
		await play_sound(whir_sfx)
		play_sound(whir_sfx)
		while anim_player.is_playing():
			await get_tree().create_timer(0.2).timeout
		Globals.bot_left.emit()
		print("emit")
		return true
	else:
		anim_player.play("Move In")
		await play_sound(whir_sfx)
		play_sound(whir_sfx)
		await anim_player.animation_finished
		print(true)
		return true

func play_sound(sound : AudioStream) -> bool:
	whir.stream = sound
	whir.play()
	await whir.finished
	return true

func enter_anim() -> bool:
	return true

func wrong() -> void:
	%WRONG.play()
	can_take_input = false
	%CenterContainer.visible = false
	%CenterContainer3.visible = true
	for i in range(3):
		%Cross.visible = true
		await get_tree().create_timer(0.2).timeout
		%Cross.visible = false
		await get_tree().create_timer(0.2).timeout
	can_take_input = true
	%CenterContainer.visible = true
	%CenterContainer3.visible = false
