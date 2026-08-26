extends Node3D

@onready var bet_label : RichTextLabel = %"Bet Label"
@onready var dice_label : RichTextLabel = %"Dice Label"
@onready var sv : SubViewport = %SubViewport
@onready var screen : MeshInstance3D = %MeshInstance3D

var num_bet : int = 0
var dice_bet : int = 0

var min_bet = 1

func _on_bet_up_pressed() -> void:
	set_num_bet(1)

func _on_bet_down_pressed() -> void:
	set_num_bet(-1)

func _on_dice_up_pressed() -> void:
	set_dice_bet(1)

func _on_dice_down_pressed() -> void:
	set_dice_bet(-1)

#TODO replace min_bet with something
func set_num_bet(dir: int) -> void:
	var new_bet : int = num_bet + dir
	if new_bet < min_bet:
		return
	num_bet = new_bet
	bet_label.text = str(num_bet) 

func set_dice_bet(dir: int) ->void:
	var new_bet : int = dice_bet + dir
	if new_bet < min_bet:
		return
	dice_bet = new_bet
	dice_label.text = str(dice_bet) 


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("LMB"):
		var translated_event: InputEvent = InputEventMouseButton.new()
		translated_event.button_index = 1
		translated_event.pressed = true
		
		var temp_scale = screen.scale
		#var translated_mouse_pos : Vector2 = Vector2(temp_scale.x, temp_scale.y) * mouse_pos
		
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
