extends Node3D

@onready var player_node : Node3D = %"Player"
@onready var camera : Camera3D = %"Player Camera"
@onready var cup : Node3D = %"Player Cup"
@onready var cup_pos : Vector3 = cup.global_position
@onready var cup_bounds : MeshInstance3D = %"Cup Bounds"
@onready var cup_bounds_qm : QuadMesh = cup_bounds.mesh
@onready var spawner : Node3D = %"Dice Spawner"
@onready var player_dice : Node3D = %"Player Dice"
@onready var pub_info : Node = %PublicInformation
var boundL : float
var boundR : float
var boundT : float
var boundB : float
var cup_start_pos : Vector3
var cup_start_rot : Vector3

var can_hold : bool = true
var is_holding : bool = false
var is_shaking : bool = false

@export_group("Cup Parameters")
@export var shake_height : float = 0.15
@export var shake_speed : float = 25
@export var depth_offset : float =  2.0
var time_passed : float = 0.0

@onready var bot : Node3D = %"Betting Bot"
@onready var playmat : Node3D = %Playmat

func _ready() -> void:
	set_cup_bounds()
	cup_start_pos = cup.global_position
	cup_start_rot = cup.global_rotation
	
	Globals.playmat_button_pressed.connect(playmat_button_pressed)
	
	for die in player_dice.get_children():
		die.visible = false
	
	if not Globals.ran_test:
		is_holding = true
		await fukcing_roll_hellllll_yeah(true)
		await %"Environment Flavor".play_all_events()
		Globals.ran_test = true
		get_tree().reload_current_scene()
	else:
		await get_tree().create_timer(1.0).timeout
		Globals.main_loaded.emit()
		get_viewport().warp_mouse(get_viewport().get_visible_rect().size/2)

func _process(delta: float) -> void:
	if not can_hold:
		is_holding = false
		is_shaking = false
	if is_holding:
		follow_mouse()
	if is_shaking:
		shake_cup(delta)

#TODO redo input for rolling
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") and can_hold and cup.mouse_over:
		is_holding = true
		is_shaking = true
	elif event.is_action_released("LMB") and can_hold:
		is_holding = false
		cup.global_position = cup_pos
	
	#if is_holding and event.is_action_pressed("RMB"):
		#is_shaking = true
	if (not is_holding and is_shaking):
		is_shaking = false
		fukcing_roll_hellllll_yeah()
	
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("ui_cancel"):
		reset()

func reset() -> void:
	for die in player_dice.get_children():
		die.visible = false
		die.display_value(false)
	return_cup()
	can_hold = true


#draws a ray from the camera to the mouse position
#defines a plane at an offset facing toward the camera
#places the cup at the point where the ray and the plane intersect
func follow_mouse() -> void:
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var ray_start : Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_direction : Vector3 = camera.project_ray_normal(mouse_pos)
	
	var plane := Plane(Vector3.BACK, cup.global_position.z)
	var intersection : Vector3 = plane.intersects_ray(ray_start, ray_direction)
	
	npc_fukcing_LETS_GO_HELL_YEAH()
	
	if intersection:
		cup.global_position = Vector3(clamp(intersection.x, boundL, boundR), clamp(intersection.y, boundB, boundT), intersection.z)

func shake_cup(delta: float) -> void:
	time_passed += delta
	cup.global_position.y = cup.global_position.y + sin(time_passed * shake_speed) * shake_height

func return_cup() -> void:
	cup.global_position = cup_start_pos
	cup.global_rotation = cup_start_rot

func fukcing_roll_hellllll_yeah(instant: bool = false) -> bool:	
	can_hold = false
	cup.can_play_sound = false
	
	var tween := get_tree().create_tween()
	if not instant:
		await tween.tween_property(cup, "global_position", Vector3(cup.global_position.x, cup.global_position.y + 5.0, cup.global_position.z), 0.25).finished
	
	tween.kill()
	tween = get_tree().create_tween()
	
	cup.global_position = playmat.cup_placer.global_position + Vector3(0,5,0)
	cup.global_rotation.z += deg_to_rad(180)
	
	if not instant:
		await tween.tween_property(cup, "global_position", playmat.cup_placer.global_position + Vector3(0,cup.get_node("%CollisionShape3D").shape.size.y,0), 0.25).finished
	
		await get_tree().create_timer(1.0).timeout
	
	tween.kill()
	tween = get_tree().create_tween()
	
	spawner.spawn_objects()
	
	if not instant:
		tween.tween_property(cup, "global_position", Vector3(cup.global_position.x, cup.global_position.y + 5.0, cup.global_position.z), 0.25)
	
		await get_tree().create_timer(1.0).timeout
	
	var current_dice : Array[int] = await place_dice()
	pub_info.set_dice_value(current_dice)
	
	playmat.set_buttons("BET", true)
	
	return true

func place_dice() -> Array[int]:
	var dice_array : Array[int] = []
	#wait to make sure all dice have stopped moving
	#if not by like 2 seconds then force them to stop moving
	for die in player_dice.get_children():
		var tries := 5
		while not die.sleeping:
			if tries <= 0:
				die.sleeping = true
				break
			tries -= 1
			await get_tree().create_timer(0.1).timeout
			continue
	
	#move the dice to the tray
	for die in player_dice.get_children():
		var slot_name : String = die.name
		var tween = get_tree().create_tween()
		tween.tween_property(die, "global_position", playmat.slot_dict[slot_name].global_position, 0.15)
		await tween.finished
		tween.kill()
		
		die.global_position = playmat.slot_dict[slot_name].global_position
		
		die.snap_to_world_axes()
		await get_tree().process_frame
		die.display_value(true)
		await get_tree().create_timer(0.1).timeout
		dice_array.append(die.dice_value)
		
	return dice_array

func playmat_button_pressed(type: String) -> void:
	match type:
		"CALL":
			pub_info.set_call_pressed(true)
		"BET":
			bot.enter()
	playmat.set_buttons("BOTH", false)

func npc_fukcing_LETS_GO_HELL_YEAH():
	for curr_character in %PublicInformation.turn_order:
		if curr_character == 'player':
			continue
		Dialogue.set_dialogue(curr_character+"_shake")

func set_cup_bounds():
	var w = cup_bounds_qm.size.x / 2.0
	var h = cup_bounds_qm.size.y / 2.0
	
	boundL = cup_bounds.global_position.x - w
	boundR = cup_bounds.global_position.x + w
	boundT = cup_bounds.global_position.y + h
	boundB = cup_bounds.global_position.y - h
